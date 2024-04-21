//// The test runner implementation specific to the Erlang target.

@target(erlang)
import gleam/dynamic.{type Dynamic}
@target(erlang)
import gleam/list
@target(erlang)
import gleam/pair
@target(erlang)
import gleam/string
@target(erlang)
import startest/context.{type Context}
@target(erlang)
import startest/internal/runner/core
@target(erlang)
import startest/locator.{TestFunction, TestSourceFile}

@target(erlang)
pub fn run_tests(ctx: Context) -> Nil {
  let assert Ok(test_files) = locator.locate_test_files(ctx)

  let tests =
    test_files
    |> list.map(fn(test_file) {
      let erlang_module_name =
        test_file.module_name
        |> gleam_module_name_to_erlang_module_name
        |> binary_to_atom

      let tests =
        get_exports(erlang_module_name)
        |> list.map(fn(pair) {
          let #(name, body) =
            pair
            |> pair.map_first(atom_to_binary)

          TestFunction(
            module_name: test_file.module_name,
            name: name,
            body: body,
          )
        })

      TestSourceFile(..test_file, tests: tests)
    })
    |> locator.identify_tests(ctx)

  tests
  |> core.run_tests(ctx)
}

@target(erlang)
fn gleam_module_name_to_erlang_module_name(module_name: String) -> String {
  module_name
  |> string.replace("/", "@")
}

@target(erlang)
type Atom

@target(erlang)
@external(erlang, "startest_ffi", "get_exports")
fn get_exports(module_name: Atom) -> List(#(Atom, fn() -> Dynamic))

@target(erlang)
@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(string: String) -> Atom

@target(erlang)
@external(erlang, "erlang", "atom_to_binary")
fn atom_to_binary(atom: Atom) -> String
