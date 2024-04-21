import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/result.{try}
import gleam/string
import simplifile
import startest/context.{type Context}
import startest/logger
import startest/test_case.{type Test, Test}
import startest/test_tree.{type TestTree, decode_test_tree}

/// Returns the list of files in the `test/` directory.
pub fn locate_test_files() -> Result(List(String), Nil) {
  use test_files <- try(
    simplifile.get_files(in: "test")
    |> result.nil_error,
  )

  let gleam_test_files =
    test_files
    |> list.filter(fn(filename) { string.ends_with(filename, ".gleam") })

  Ok(gleam_test_files)
}

pub type NamedFunction =
  #(String, fn() -> Dynamic)

pub fn identify_tests(
  test_functions: List(NamedFunction),
  ctx: Context,
) -> List(TestTree) {
  let #(standalone_tests, test_functions) =
    test_functions
    |> list.partition(is_standalone_test)
  let standalone_tests =
    standalone_tests
    |> list.map(fn(named_fn) {
      let #(function_name, function) = named_fn

      let function: fn() -> Nil =
        function
        |> dynamic.from
        |> dynamic.unsafe_coerce

      Test(function_name, function, False)
      |> test_tree.Test
    })

  let #(test_suites, _test_functions) =
    test_functions
    |> list.partition(is_test_suite)
  let test_suites =
    test_suites
    |> list.filter_map(fn(named_fn) {
      let #(_function_name, function) = named_fn

      let value = function()

      decode_test_tree(value)
      |> result.map_error(fn(error) {
        logger.error(ctx.logger, string.inspect(error))
      })
    })

  list.concat([test_suites, standalone_tests])
}

fn is_standalone_test(named_fn: NamedFunction) -> Bool {
  let #(function_name, _) = named_fn

  function_name
  |> string.ends_with("_test")
}

fn is_test_suite(named_fn: NamedFunction) -> Bool {
  let #(function_name, _) = named_fn

  function_name
  |> string.ends_with("_tests")
}
