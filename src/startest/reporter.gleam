import bigben/clock
import birl
import birl/duration.{type Duration}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import gleam_community/ansi
import startest/context.{type Context}
import startest/locator.{type TestFile}
import startest/logger
import startest/test_case.{type ExecutedTest, type Test}
import startest/test_failure.{type TestFailure}

pub fn report_summary(
  ctx: Context,
  test_files: List(TestFile),
  tests: List(ExecutedTest),
  failed_tests: List(#(Test, TestFailure)),
  execution_duration: Duration,
  reporting_duration: Duration,
) {
  let total_test_count = list.length(tests)
  let failed_test_count = list.length(failed_tests)
  let passed_test_count = total_test_count - failed_test_count
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

  let total_duration =
    clock.now(ctx.clock)
    |> birl.difference(ctx.started_at)

  let passed_tests = case passed_test_count {
    0 -> None
    _ -> Some(ansi.bright_green(int.to_string(passed_test_count) <> " passed"))
  }
  let failed_tests = case failed_test_count {
    0 -> None
    _ -> Some(ansi.bright_red(int.to_string(failed_test_count) <> " failed"))
  }
  let total_tests = ansi.gray("(" <> int.to_string(total_test_count) <> ")")

  let failed_or_passed_tests = case passed_tests, failed_tests {
    Some(passed_tests), Some(failed_tests) ->
      failed_tests <> " | " <> passed_tests
    Some(tests), None | None, Some(tests) -> tests
    None, None -> ""
  }

  let total_collect_duration =
    test_files
    |> list.fold(duration.micro_seconds(0), fn(acc, test_file) {
      duration.add(acc, test_file.collect_duration)
    })

  let label = fn(text) { ansi.dim(ansi.white(text)) }

  logger.log(
    ctx.logger,
    label("Test Files: ") <> int.to_string(list.length(test_files)),
  )
  logger.log(
    ctx.logger,
    label("     Tests: ") <> failed_or_passed_tests <> " " <> total_tests,
  )
  logger.log(
    ctx.logger,
    label("Started at: ")
      <> {
      // TODO: Show in local time.
      ctx.started_at
      |> birl.to_naive_time_string
      |> string.slice(0, string.length("HH:MM:SS"))
    },
  )
  logger.log(
    ctx.logger,
    label("  Duration: ")
      <> duration_to_string(total_duration)
      <> " "
      <> label(
      "(collect "
      <> duration_to_string(total_collect_duration)
      <> ", tests "
      <> duration_to_string(execution_duration)
      <> ", reporters "
      <> duration_to_string(reporting_duration)
      <> ")",
    ),
  )
}

fn duration_to_string(duration: duration.Duration) -> String {
  let parts = duration.decompose(duration)

  case parts {
    [#(microseconds, duration.MicroSecond)] ->
      int.to_string(microseconds) <> "µs"
    [#(milliseconds, duration.MilliSecond), #(_, duration.MicroSecond)] ->
      int.to_string(milliseconds) <> "ms"
    [
      #(seconds, duration.Second),
      #(_, duration.MilliSecond),
      #(_, duration.MicroSecond),
    ] -> int.to_string(seconds) <> "s"
    [
      #(minutes, duration.Minute),
      #(_, duration.Second),
      #(_, duration.MilliSecond),
      #(_, duration.MicroSecond),
    ] -> int.to_string(minutes) <> "m"
    _ -> "too long"
  }
}
