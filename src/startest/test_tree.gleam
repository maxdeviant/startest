import gleam/list
import gleam/string
import startest/test_case.{type Test}

pub type TestTree {
  Suite(name: String, suite: List(TestTree))
  Test(Test)
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
