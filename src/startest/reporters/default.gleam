import gleam_community/ansi
import startest/logger
import startest/reporters.{type Reporter, Reporter}
import startest/test_case.{Failed, Passed, Skipped}

pub fn new() -> Reporter {
  Reporter(
    report: fn(ctx, executed_test) {
      let test_case = executed_test.test_case
      case executed_test.outcome {
        Passed ->
          logger.log(ctx.logger, ansi.green("✓") <> " " <> test_case.name)
        Failed(_failure) -> {
          logger.log(ctx.logger, ansi.red("×") <> " " <> test_case.name)
        }
        Skipped ->
          logger.log(ctx.logger, ansi.gray("~") <> " " <> test_case.name)
      }
    },
    finished: fn(_ctx) { Nil },
  )
}
