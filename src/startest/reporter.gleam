import bigben/clock
import gleam/int
import gleam/list
import gleam/option.{None, Some}

import gleam/string
import gleam/time/calendar
import gleam/time/duration.{type Duration}
import gleam/time/timestamp
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
  skipped_tests: List(Test),
  failed_tests: List(#(Test, TestFailure)),
  discovery_duration: Duration,
  execution_duration: Duration,
  reporting_duration: Duration,
) {
  let total_test_count = list.length(tests)
  let skipped_test_count = list.length(skipped_tests)
  let failed_test_count = list.length(failed_tests)
  let passed_test_count =
    total_test_count - skipped_test_count - failed_test_count
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
    ctx.started_at
    |> timestamp.difference(clock.now(ctx.clock))

  let passed_tests = case passed_test_count {
    0 -> None
    _ -> Some(ansi.bright_green(int.to_string(passed_test_count) <> " passed"))
  }
  let skipped_tests = case skipped_test_count {
    0 -> None
    _ -> Some(ansi.yellow(int.to_string(skipped_test_count) <> " skipped"))
  }
  let failed_tests = case failed_test_count {
    0 -> None
    _ -> Some(ansi.bright_red(int.to_string(failed_test_count) <> " failed"))
  }
  let total_tests = ansi.gray("(" <> int.to_string(total_test_count) <> ")")

  let tests_by_category =
    [passed_tests, skipped_tests, failed_tests]
    |> list.filter_map(option.to_result(_, Nil))
    |> string.join(" | ")

  let total_collect_duration =
    test_files
    |> list.fold(duration.nanoseconds(0), fn(acc, test_file) {
      duration.add(acc, test_file.collect_duration)
    })

  let label = fn(text) { ansi.dim(ansi.white(text)) }

  logger.log(
    ctx.logger,
    label("Test Files: ") <> int.to_string(list.length(test_files)),
  )
  logger.log(
    ctx.logger,
    label("     Tests: ") <> tests_by_category <> " " <> total_tests,
  )
  logger.log(
    ctx.logger,
    label("Started at: ")
      <> {
      ctx.started_at
      |> timestamp.to_rfc3339(calendar.local_offset())
      |> string.slice(string.length("YYYY-MM-DDT"), string.length("HH:MM:SS"))
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

fn duration_to_string(duration: Duration) -> String {
  let DurationComponents(minutes, seconds, milliseconds, microseconds) =
    decompose_duration(duration)

  case True {
    _ if minutes > 0 -> int.to_string(minutes) <> "m"
    _ if seconds > 0 -> int.to_string(seconds) <> "s"
    _ if milliseconds > 0 -> int.to_string(milliseconds) <> "ms"
    _ if microseconds > 0 -> int.to_string(microseconds) <> "µs"
    _ -> "0µs"
  }
}

type DurationComponents {
  DurationComponents(
    minutes: Int,
    seconds: Int,
    milliseconds: Int,
    microseconds: Int,
  )
}

fn decompose_duration(duration: Duration) -> DurationComponents {
  let #(total_seconds, nanoseconds) =
    duration.to_seconds_and_nanoseconds(duration)

  let minutes = total_seconds / 60
  let seconds = total_seconds % 60

  let milliseconds = nanoseconds / 1_000_000
  let remaining_nanoseconds = nanoseconds % 1_000_000

  let microseconds = remaining_nanoseconds / 1000

  DurationComponents(minutes:, seconds:, milliseconds:, microseconds:)
}
