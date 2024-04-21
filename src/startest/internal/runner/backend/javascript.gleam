//// The test runner implementation specific to the JavaScript target.

@target(javascript)
import gleam/dynamic.{type Dynamic}
@target(javascript)
import gleam/javascript/array.{type Array}
@target(javascript)
import gleam/javascript/promise.{type Promise}
@target(javascript)
import gleam/list
@target(javascript)
import startest/context.{type Context}
@target(javascript)
import startest/internal/gleam_toml
@target(javascript)
import startest/internal/runner/core
@target(javascript)
import startest/locator

@target(javascript)
pub fn run_tests(ctx: Context) -> Promise(Nil) {
  let assert Ok(test_files) = locator.locate_test_files()
  let assert Ok(package_name) = gleam_toml.read_name()

  use tests <- promise.await(
    test_files
    |> list.map(fn(test_file) {
      let js_module_path =
        "../" <> package_name <> "/" <> test_file.module_name <> ".mjs"

      get_exports(js_module_path)
      |> promise.map(array.to_list)
    })
    |> promise.await_list
    |> promise.map(list.flatten)
    |> promise.map(locator.identify_tests(_, ctx)),
  )

  tests
  |> core.run_tests(ctx)
  |> promise.resolve
}

@target(javascript)
@external(javascript, "../../../../startest_ffi.mjs", "get_exports")
fn get_exports(
  module_path: String,
) -> Promise(Array(#(String, fn() -> Dynamic)))
