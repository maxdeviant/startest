import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/regex
import gleam/result.{try}
import gleam/string
import simplifile
import startest/context.{type Context}
import startest/logger
import startest/test_case.{type Test, Test}
import startest/test_tree.{
  type TestLocation, type TestTree, TestLocation, decode_test_tree,
}

/// A file in the `test/` directory that likely contains tests.
pub type TestFile {
  TestFile(
    /// The filepath to the `.gleam` file.
    filepath: String,
    /// The name of the Gleam module.
    module_name: String,
  )
}

/// Returns the list of files in the `test/` directory.
pub fn locate_test_files(ctx: Context) -> Result(List(TestFile), Nil) {
  use test_files <- try(
    simplifile.get_files(in: "test")
    |> result.nil_error,
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
    let module_name = filepath_to_module_name(filepath)
    TestFile(filepath, module_name)
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

pub fn identify_tests(
  test_functions: List(TestFunction),
  ctx: Context,
) -> List(#(TestTree, TestLocation)) {
  let #(standalone_tests, test_functions) =
    test_functions
    |> list.partition(is_standalone_test(_, ctx))
  let standalone_tests =
    standalone_tests
    |> list.map(fn(test_function) {
      let function: fn() -> Nil =
        test_function.body
        |> dynamic.from
        |> dynamic.unsafe_coerce

      #(
        Test(test_function.name, function, False)
          |> test_tree.Test,
        TestLocation(test_function.module_name),
      )
    })

  let #(test_suites, _test_functions) =
    test_functions
    |> list.partition(is_test_suite(_, ctx))
  let test_suites =
    test_suites
    |> list.filter_map(fn(test_function) {
      test_function.body()
      |> decode_test_tree
      |> result.map(fn(test_tree) {
        #(test_tree, TestLocation(test_function.module_name))
      })
      |> result.map_error(fn(error) {
        logger.error(ctx.logger, string.inspect(error))
      })
    })

  list.concat([test_suites, standalone_tests])
}

fn is_standalone_test(test_function: TestFunction, ctx: Context) -> Bool {
  test_function.name
  |> regex.check(with: ctx.config.discover_standalone_tests_pattern)
}

fn is_test_suite(test_function: TestFunction, ctx: Context) -> Bool {
  test_function.name
  |> regex.check(with: ctx.config.discover_describe_tests_pattern)
}
