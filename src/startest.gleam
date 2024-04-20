import startest/reporter.{type Reporter}
import startest/runner
import startest/test_case.{type Test, Test}
import startest/test_tree.{type TestTree, Suite}

/// Defines a new test suite with the given name.
///
/// A suite is a way of grouping related tests together.
///
/// `describe`s may also be nested in other `describe`s to form a hierarchy of tests.
pub fn describe(name: String, suite: List(TestTree)) -> TestTree {
  Suite(name, suite)
}

/// Defines a test with the given name.
pub fn it(name: String, body: fn() -> Nil) -> TestTree {
  Test(name, body, False)
  |> test_tree.Test
}

/// Skips a test defined using `it`.
///
/// This can be used to skip running certain tests, but without deleting the code.
/// For instance, you might want to do this if a test is flaky and you want to stop
/// running it temporarily until it can be fixed.
pub fn xit(name: String, _body: fn() -> Nil) -> TestTree {
  Test(name, fn() { Nil }, True)
  |> test_tree.Test
}

/// Runs the given tests and reports results using the provided list of `Reporter`s.
pub fn run_tests(tests: List(TestTree), reporters: List(Reporter)) -> Nil {
  runner.run_tests(tests, reporters)
}
