import startest/test_case.{type ExecutedTest}

pub type Reporter {
  Reporter(report: fn(ExecutedTest) -> Nil)
}
