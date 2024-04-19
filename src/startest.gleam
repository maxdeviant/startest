import startest/runner
import startest/test_case.{type Test, Test}
import startest/test_tree.{type TestTree, Suite}

pub fn describe(name: String, suite: List(TestTree)) -> TestTree {
  Suite(name, suite)
}

pub fn it(name: String, body: fn() -> Nil) -> TestTree {
  Test(name, body, False)
  |> test_tree.Test
}

pub fn xit(name: String, _body: fn() -> Nil) -> TestTree {
  Test(name, fn() { Nil }, True)
  |> test_tree.Test
}

pub fn run_tests(tests: List(TestTree)) -> Nil {
  runner.run_tests(tests)
}
