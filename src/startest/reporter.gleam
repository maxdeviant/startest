import gleam/int
import gleam/list
import gleam_community/ansi
import startest/context.{type Context}
import startest/logger
import startest/test_case.{type Test}
import startest/test_failure.{type TestFailure}

pub fn report_summary(ctx: Context, failed_tests: List(#(Test, TestFailure))) {
  let failed_test_count = list.length(failed_tests)
  let has_any_failures = failed_test_count > 0

  case has_any_failures {
    True -> {
      logger.log(ctx.logger, "")
      logger.log(
        ctx.logger,
        ansi.black(ansi.bg_bright_red(
          " Failed Tests: " <> int.to_string(failed_test_count) <> " ",
        )),
      )
      logger.log(ctx.logger, "")

      failed_tests
      |> list.each(fn(failed_test) {
        let #(test_case, failure) = failed_test

        logger.log(
          ctx.logger,
          ansi.black(ansi.bg_bright_red(" FAIL "))
            <> " "
            <> test_case.name
            <> "\n"
            <> test_failure.to_string(failure),
        )
      })
    }
    False -> Nil
  }
}
