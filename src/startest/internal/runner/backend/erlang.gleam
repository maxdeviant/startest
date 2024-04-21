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
import startest/locator
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
    |> locator.identify_tests(ctx)

  core.run_tests(ctx, list.concat([tests, test_functions]))
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
fn get_exports(module_name: Atom) -> List(#(Atom, fn() -> Dynamic))

@target(erlang)
@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(string: String) -> Atom

@target(erlang)
@external(erlang, "erlang", "atom_to_binary")
fn atom_to_binary(atom: Atom) -> String
