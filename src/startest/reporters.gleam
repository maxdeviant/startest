import startest/logger.{type Logger}
import startest/test_case.{type ExecutedTest}

pub type ReporterContext {
  ReporterContext(logger: Logger)
}

pub type Reporter {
  Reporter(
    report: fn(ReporterContext, ExecutedTest) -> Nil,
    finished: fn(ReporterContext) -> Nil,
  )
}
