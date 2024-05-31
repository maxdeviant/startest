import bigben/clock
import birl
import birl/duration.{type Duration}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
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
  skipped_tests: List(ExecutedTest),
  failed_tests: List(#(Test, TestFailure)),
  discovery_duration: Duration,
  execution_duration: Duration,
  reporting_duration: Duration,
) {
  let total_test_count = list.length(tests)
  let skipped_test_count = list.length(skipped_tests)
  let failed_test_count = list.length(failed_tests)
  let passed_test_count =
    total_test_count - failed_test_count - skipped_test_count
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
  let skipped_tests = case skipped_test_count {
    0 -> None
    _ -> Some(ansi.magenta(int.to_string(skipped_test_count) <> " skipped"))
  }
  let failed_tests = case failed_test_count {
    0 -> None
    _ -> Some(ansi.bright_red(int.to_string(failed_test_count) <> " failed"))
  }
  let total_tests = ansi.gray("(" <> int.to_string(total_test_count) <> ")")

  let test_statistics = case passed_tests, skipped_tests, failed_tests {
    Some(passed_tests), Some(skipped_tests), Some(failed_tests) ->
      failed_tests <> " | " <> skipped_tests <> " | " <> passed_tests
    Some(tests1), Some(tests2), None
    | Some(tests1), None, Some(tests2)
    | None, Some(tests1), Some(tests2)
    -> tests1 <> " | " <> tests2
    Some(tests), None, None | None, Some(tests), None | None, None, Some(tests) ->
      tests
    None, None, None -> ""
  }

  let started_at =
    ctx.started_at
    |> birl.set_offset(
      birl.now()
      |> birl.get_offset,
    )
    |> result.unwrap(ctx.started_at)

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
    label("     Tests: ") <> test_statistics <> " " <> total_tests,
  )
  logger.log(
    ctx.logger,
    label("Started at: ")
      <> {
      started_at
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
      "(discover "
      <> duration_to_string(discovery_duration)
      <> ", collect "
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
