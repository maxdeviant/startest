//// The test runner implementation specific to the Erlang target.

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
import startest/locator
@target(erlang)
import startest/test_case.{Test}
@target(erlang)
import startest/test_tree.{type TestTree}

@target(erlang)
pub fn run_tests(ctx: Context, tests: List(TestTree)) -> Nil {
  let assert Ok(test_files) = locator.locate_test_files()

  let test_functions =
    test_files
    |> list.map(fn(filepath) {
      let erlang_module_name =
        filepath
        |> gleam_module_name_to_erlang_module_name
        |> binary_to_atom

      get_exports(erlang_module_name)
      |> list.map(pair.map_first(_, atom_to_binary))
    })
    |> list.flatten
    |> list.filter(fn(export) {
      let #(export_name, _) = export

      string.ends_with(export_name, "_test")
    })

  let test_cases =
    test_functions
    |> list.map(fn(export) {
      let #(function_name, function) = export

      Test(function_name, function, False)
      |> test_tree.Test
    })

  core.run_tests(ctx, list.concat([tests, test_cases]))
}

@target(erlang)
fn gleam_module_name_to_erlang_module_name(filepath: String) -> String {
  filepath
  |> string.slice(
    at_index: string.length("test/"),
    length: string.length(filepath),
  )
  |> string.replace(".gleam", "")
  |> string.replace("/", "@")
}

@target(erlang)
type Atom

@target(erlang)
@external(erlang, "startest_ffi", "get_exports")
fn get_exports(module_name: Atom) -> List(#(Atom, fn() -> Nil))

@target(erlang)
@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(string: String) -> Atom

@target(erlang)
@external(erlang, "erlang", "atom_to_binary")
fn atom_to_binary(atom: Atom) -> String
