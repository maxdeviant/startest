import gleam/dynamic/decode.{type Decoder}
import gleam/list
import gleam/string
import startest/test_case.{type Test, test_decoder}

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

@target(erlang)
pub fn test_tree_decoder() -> Decoder(TestTree) {
  decode.one_of(
    {
      use name <- decode.then(decode.at([1], decode.string))
      use suite <- decode.then(decode.at([2], decode.list(test_tree_decoder())))
      decode.success(Suite(name, suite))
    },
    [decode.at([1], test_decoder()) |> decode.map(Test)],
  )
}

@target(javascript)
pub fn test_tree_decoder() -> Decoder(TestTree) {
  decode.one_of(
    {
      use name <- decode.field("name", decode.string)
      use suite <- decode.field("suite", decode.list(test_tree_decoder()))
      decode.success(Suite(name, suite))
    },
    [decode.field("0", test_decoder(), decode.success) |> decode.map(Test)],
  )
}
