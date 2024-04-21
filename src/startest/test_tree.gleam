import gleam/dynamic.{type DecodeError, type Dynamic} as dyn
import gleam/list
import gleam/string
import startest/test_case.{type Test, decode_test}

pub type TestTree {
  Suite(name: String, suite: List(TestTree))
  Test(Test)
}

pub type TestLocation {
  TestLocation(module_name: String)
}

pub fn all_tests(tree: TestTree) -> List(#(String, Test)) {
  collect_all_tests(tree, [], [])
}

fn collect_all_tests(
  tree: TestTree,
  path: List(String),
  acc: List(#(String, Test)),
) -> List(#(String, Test)) {
  case tree {
    Suite(name, suite) ->
      suite
      |> list.flat_map(collect_all_tests(_, [name, ..path], acc))
    Test(test_case) -> {
      let test_path =
        [test_case.name, ..path]
        |> list.reverse
        |> string.join(" ❯ ")

      [#(test_path, test_case), ..acc]
    }
  }
}

@target(erlang)
pub fn decode_test_tree(value: Dynamic) -> Result(TestTree, List(DecodeError)) {
  value
  |> dyn.any([
    dyn.decode2(
      Suite,
      dyn.element(1, dyn.string),
      dyn.element(2, dyn.list(decode_test_tree)),
    ),
    dyn.decode1(Test, dyn.element(1, decode_test)),
  ])
}

@target(javascript)
pub fn decode_test_tree(value: Dynamic) -> Result(TestTree, List(DecodeError)) {
  value
  |> dyn.any([
    dyn.decode2(
      Suite,
      dyn.field("name", dyn.string),
      dyn.field("suite", dyn.list(decode_test_tree)),
    ),
    dyn.decode1(Test, dyn.field("0", decode_test)),
  ])
}
