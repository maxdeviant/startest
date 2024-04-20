import birl
import birl/duration
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import gleam_community/ansi
import startest/config.{type Config}
import startest/internal/process
import startest/test_case.{
  type Test, type TestOutcome, ExecutedTest, Failed, Passed, Skipped,
}
import startest/test_failure
import startest/test_tree.{type TestTree}

pub fn run_tests(tests: List(TestTree), config: Config) {
  let started_at = birl.utc_now()

  let tests =
    tests
    |> list.flat_map(fn(tree) { test_tree.all_tests(tree) })
    |> list.filter(fn(pair) {
      let #(test_name, _) = pair

      case config.test_name_pattern {
        Some(test_name_pattern) ->
          string.contains(does: test_name, contain: test_name_pattern)
        None -> True
      }
    })

  let test_count = list.length(tests)
  io.println("Running " <> int.to_string(test_count) <> " tests")

  let execution_started_at = birl.utc_now()

  let executed_tests =
    tests
    |> list.map(fn(pair) {
      let test_case =
        test_case.Test(pair.0, { pair.1 }.body, { pair.1 }.skipped)

      ExecutedTest(test_case, run_test(test_case))
    })

  let execution_duration =
    birl.utc_now()
    |> birl.difference(execution_started_at)

  config.reporters
  |> list.each(fn(reporter) {
    executed_tests
    |> list.each(fn(executed_test) { reporter.report(executed_test) })

    reporter.finished()
  })

  let failed_tests =
    executed_tests
    |> list.filter_map(fn(executed_test) {
      case executed_test.outcome {
        Failed(failure) -> Ok(#(executed_test.test_case, failure))
        Passed | Skipped -> Error(Nil)
      }
    })
  let failed_test_count = list.length(failed_tests)
  let has_any_failures = failed_test_count > 0

  case has_any_failures {
    True -> {
      io.println("")
      io.println(
        ansi.black(ansi.bg_bright_red(
          " Failed Tests: " <> int.to_string(failed_test_count) <> " ",
        )),
      )
      io.println("")

      failed_tests
      |> list.each(fn(failed_test) {
        let #(test_case, failure) = failed_test

        io.println(
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
    birl.utc_now()
    |> birl.difference(started_at)

  io.println(
    "Ran "
    <> int.to_string(test_count)
    <> " tests in "
    <> duration_to_string(total_duration),
  )
  io.println("Execution time: " <> duration_to_string(execution_duration))

  let exit_code = case has_any_failures {
    True -> 1
    False -> 0
  }

  process.exit(exit_code)
}

fn run_test(test_case: Test) -> TestOutcome {
  case test_case.skipped {
    True -> Skipped
    False -> {
      case test_failure.rescue(test_case.body) {
        Ok(Nil) -> Passed
        Error(err) -> Failed(err)
      }
    }
  }
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
