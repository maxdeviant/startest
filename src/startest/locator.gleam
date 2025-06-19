import bigben/clock
import birl
import birl/duration.{type Duration}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/regexp as regex
import gleam/result.{try}
import gleam/string
import simplifile
import startest/context.{type Context}
import startest/internal/unsafe
import startest/logger
import startest/test_case.{Test}
import startest/test_tree.{type TestTree, test_tree_decoder}

/// A file that contains tests.
pub type TestFile {
  TestFile(
    /// The name of the Gleam module.
    module_name: String,
    /// The filepath to the `.gleam` file.
    filepath: String,
    /// The list of tests in the file.
    tests: List(TestTree),
    /// The time it took to collect the tests in the file.
    collect_duration: Duration,
  )
}

/// A file in the `test/` directory that likely contains tests.
pub type TestSourceFile {
  TestSourceFile(
    /// The name of the Gleam module.
    module_name: String,
    /// The filepath to the `.gleam` file.
    filepath: String,
    /// The list of tests in the file.
    tests: List(TestFunction),
  )
}

/// Returns the list of files in the `test/` directory.
pub fn locate_test_files(ctx: Context) -> Result(List(TestSourceFile), Nil) {
  use test_files <- try(
    simplifile.get_files(in: "test")
    |> result.replace_error(Nil),
  )

  test_files
  |> list.filter(fn(filepath) { string.ends_with(filepath, ".gleam") })
  |> list.filter(fn(filepath) {
    case ctx.config.filters {
      [] -> True
      filters ->
        list.any(in: filters, satisfying: fn(filter) {
          string.contains(does: filepath, contain: filter)
        })
    }
  })
  |> list.map(fn(filepath) {
    TestSourceFile(
      module_name: filepath_to_module_name(filepath),
      filepath: filepath,
      tests: [],
    )
  })
  |> Ok
}

/// Returns the Gleam module name from the given filepath.
fn filepath_to_module_name(filepath: String) -> String {
  filepath
  |> string.slice(
    at_index: string.length("test/"),
    length: string.length(filepath),
  )
  |> string.replace(".gleam", "")
}

pub type TestFunction {
  TestFunction(module_name: String, name: String, body: fn() -> Dynamic)
}

/// Identifies all of the tests contained in the given list of `TestSourceFile`s.
///
/// Any files that don't have any tests will be excluded from the result.
pub fn identify_tests(
  test_files: List(TestSourceFile),
  ctx: Context,
) -> List(TestFile) {
  test_files
  |> list.filter_map(identify_tests_in_file(_, ctx))
}

fn identify_tests_in_file(
  test_file: TestSourceFile,
  ctx: Context,
) -> Result(TestFile, Nil) {
  let started_at = clock.now(ctx.clock)

  let #(standalone_tests, test_functions) =
    test_file.tests
    |> list.partition(is_standalone_test(_, ctx))
  let standalone_tests =
    standalone_tests
    |> list.map(fn(test_function) {
      let function: fn() -> Nil =
        test_function.body
        |> dynamic.from
        |> unsafe.coerce

      Test(test_function.name, function, False)
      |> test_tree.Test
    })

  let #(test_suites, _test_functions) =
    test_functions
    |> list.partition(is_test_suite(_, ctx))
  let test_suites =
    test_suites
    |> list.filter_map(fn(test_function) {
      test_function.body()
      |> decode.run(test_tree_decoder())
      |> result.map_error(fn(error) {
        logger.error(ctx.logger, string.inspect(error))
      })
    })

  let tests = list.flatten([test_suites, standalone_tests])

  case tests {
    [] -> Error(Nil)
    tests -> {
      let collect_duration =
        clock.now(ctx.clock)
        |> birl.difference(started_at)

      Ok(TestFile(
        module_name: test_file.module_name,
        filepath: test_file.filepath,
        tests: tests,
        collect_duration: collect_duration,
      ))
    }
  }
}

fn is_standalone_test(test_function: TestFunction, ctx: Context) -> Bool {
  test_function.name
  |> regex.check(with: ctx.config.discover_standalone_tests_pattern)
}

fn is_test_suite(test_function: TestFunction, ctx: Context) -> Bool {
  test_function.name
  |> regex.check(with: ctx.config.discover_describe_tests_pattern)
}
