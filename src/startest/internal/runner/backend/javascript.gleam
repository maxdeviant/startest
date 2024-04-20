//// The test runner implementation specific to the JavaScript target.

@target(javascript)
import gleam/javascript/array.{type Array}
@target(javascript)
import gleam/javascript/promise.{type Promise}
@target(javascript)
import gleam/list
@target(javascript)
import gleam/string
@target(javascript)
import startest/context.{type Context}
@target(javascript)
import startest/internal/runner/core
@target(javascript)
import startest/locator
@target(javascript)
import startest/test_case.{Test}
@target(javascript)
import startest/test_tree.{type TestTree}

@target(javascript)
pub fn run_tests(ctx: Context, tests: List(TestTree)) -> Promise(Nil) {
  let assert Ok(test_files) = locator.locate_test_files()

  // TODO: Retrieve package name from `gleam.toml`.
  let package_name = "startest"

  use test_functions <- promise.await(
    test_files
    |> list.map(fn(filepath) {
      let js_module_path =
        "../" <> package_name <> "/" <> gleam_filepath_to_mjs_filepath(filepath)

      get_exports(js_module_path)
      |> promise.map(array.to_list)
    })
    |> promise.await_list
    |> promise.map(list.flatten)
    |> promise.map(list.filter(_, fn(export) {
      let #(export_name, _) = export

      string.ends_with(export_name, "_test")
    })),
  )

  let test_cases =
    test_functions
    |> list.map(fn(export) {
      let #(function_name, function) = export

      Test(function_name, function, False)
      |> test_tree.Test
    })

  core.run_tests(ctx, list.concat([tests, test_cases]))
  |> promise.resolve
}

@target(javascript)
fn gleam_filepath_to_mjs_filepath(filepath: String) {
  filepath
  |> string.slice(
    at_index: string.length("test/"),
    length: string.length(filepath),
  )
  |> string.replace(".gleam", ".mjs")
}

@target(javascript)
@external(javascript, "../../../../startest_ffi.mjs", "get_exports")
fn get_exports(module_path: String) -> Promise(Array(#(String, fn() -> Nil)))
