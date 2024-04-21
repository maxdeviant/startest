import gleam/option.{type Option}
import gleam/regex.{type Regex}
import startest/reporters.{type Reporter}

pub type Config {
  Config(
    /// The list of reporters to use to report test results.
    reporters: List(Reporter),
    /// The pattern to use when discovering tests using the `describe` API.
    ///
    /// If a function's name matches the pattern it will be evaluated and expected
    /// to return a `TestTree` (like the ones returned by `describe` or `it`).
    discover_describe_tests_pattern: Regex,
    /// The pattern to use when discovering tests defined using standalone functions.
    ///
    /// If a function's name matches the pattern it will be run as a test.
    discover_standalone_tests_pattern: Regex,
    /// The list of test filepath filters.
    ///
    /// Each filter is matched against a test file's path to determine whether the
    /// tests in that file should be run.
    filters: List(String),
    /// The pattern to use to filter test names.
    test_name_pattern: Option(String),
  )
}

/// Updates the given `Config` with the specified `discover_describe_tests_pattern`.
pub fn with_discover_describe_tests_pattern(
  config: Config,
  discover_describe_tests_pattern: Regex,
) -> Config {
  Config(
    ..config,
    discover_describe_tests_pattern: discover_describe_tests_pattern,
  )
}

/// Updates the given `Config` with the specified `discover_standalone_tests_pattern`.
pub fn with_discover_standalone_tests_pattern(
  config: Config,
  discover_standalone_tests_pattern: Regex,
) -> Config {
  Config(
    ..config,
    discover_standalone_tests_pattern: discover_standalone_tests_pattern,
  )
}

/// Updates the given `Config` with the specified `filters`.
pub fn with_filters(config: Config, filters: List(String)) -> Config {
  Config(..config, filters: filters)
}

/// Updates the given `Config` with the specified `test_name_pattern`.
pub fn with_test_name_pattern(
  config: Config,
  test_name_pattern: Option(String),
) -> Config {
  Config(..config, test_name_pattern: test_name_pattern)
}
