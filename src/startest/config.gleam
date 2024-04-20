import startest/reporter.{type Reporter}
import startest/reporters/default as default_reporter

pub type Config {
  Config(
    /// The list of reporters to use to report test results.
    reporters: List(Reporter),
  )
}

/// Returns the default Startest config.
pub fn default() -> Config {
  Config(reporters: [default_reporter.new()])
}
