import gleam/option.{type Option, None}
import startest/reporter.{type Reporter}
import startest/reporters/default as default_reporter

pub type Config {
  Config(
    /// The list of reporters to use to report test results.
    reporters: List(Reporter),
    /// The pattern to use to filter test names.
    test_name_pattern: Option(String),
  )
}

/// Returns the default Startest config.
pub fn default() -> Config {
  Config(reporters: [default_reporter.new()], test_name_pattern: None)
}

pub fn with_test_name_pattern(
  config: Config,
  test_name_pattern: Option(String),
) -> Config {
  Config(..config, test_name_pattern: test_name_pattern)
}
