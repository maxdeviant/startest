import gleam/option.{type Option}
import startest/reporters.{type Reporter}

pub type Config {
  Config(
    /// The list of reporters to use to report test results.
    reporters: List(Reporter),
    /// The pattern to use to filter test names.
    test_name_pattern: Option(String),
  )
}

pub fn with_test_name_pattern(
  config: Config,
  test_name_pattern: Option(String),
) -> Config {
  Config(..config, test_name_pattern: test_name_pattern)
}
