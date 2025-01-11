import gleam/option.{None}
import gleam/regexp as regex
import startest/cli
import startest/config.{type Config, Config}
import startest/reporters/default as default_reporter
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

/// Runs Startest with the provided list of tests.
pub fn run(config: Config) {
  cli.run(config)
}

/// Returns the default Startest config.
pub fn default_config() -> Config {
  let assert Ok(discover_describe_tests_pattern) = regex.from_string("_tests$")
  let assert Ok(discover_standalone_tests_pattern) = regex.from_string("_test$")

  Config(
    reporters: [default_reporter.new()],
    discover_describe_tests_pattern: discover_describe_tests_pattern,
    discover_standalone_tests_pattern: discover_standalone_tests_pattern,
    filters: [],
    test_name_pattern: None,
  )
}
