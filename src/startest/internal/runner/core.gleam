//// The core test runner implementation.

import bigben/clock
import birl
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import startest/context.{type Context}
import startest/internal/process
import startest/locator.{type TestFile}
import startest/logger
import startest/reporter
import startest/reporters.{ReporterContext}
import startest/test_case.{
  type Test, type TestOutcome, ExecutedTest, Failed, Passed, Skipped,
}
import startest/test_failure
import startest/test_tree

pub fn run_tests(test_files: List(TestFile), ctx: Context) {
  // We should probably be storing an explicit time when we start the
  // discovery, in case we insert more operations between the time we
  // start and when we begin discovering tests, but for now we can just
  // assume that the first thing we do after starting is begin discovery.
  let discovery_duration =
    clock.now(ctx.clock)
    |> birl.difference(ctx.started_at)

  let tests =
    test_files
    |> list.flat_map(fn(test_file) {
      test_file.tests
      |> list.flat_map(test_tree.all_tests)
      |> list.map(fn(pair) {
        let #(full_test_name, test_case) = pair

        #(test_file.module_name, full_test_name, test_case)
      })
    })
    |> list.filter(fn(tuple) {
      let #(_module_name, full_test_name, _) = tuple

      case ctx.config.test_name_pattern {
        Some(test_name_pattern) ->
          string.contains(does: full_test_name, contain: test_name_pattern)
        None -> True
      }
    })

  let test_count = list.length(tests)
  logger.log(ctx.logger, "Running " <> int.to_string(test_count) <> " tests")

  let execution_started_at = clock.now(ctx.clock)

  let executed_tests =
    tests
    |> list.map(fn(tuple) {
      let #(_module_name, full_test_name, test_case) = tuple

      let test_case =
        test_case.Test(full_test_name, test_case.body, test_case.skipped)

      ExecutedTest(test_case, run_test(test_case))
    })

  let execution_duration =
    clock.now(ctx.clock)
    |> birl.difference(execution_started_at)

  let reporting_started_at = clock.now(ctx.clock)

  let reporter_ctx = ReporterContext(logger: ctx.logger)
  ctx.config.reporters
  |> list.each(fn(reporter) {
    executed_tests
    |> list.each(fn(executed_test) {
      reporter.report(reporter_ctx, executed_test)
    })

    reporter.finished(reporter_ctx)
  })

  let reporting_duration =
    clock.now(ctx.clock)
    |> birl.difference(reporting_started_at)

  let skipped_tests =
    executed_tests
    |> list.filter_map(fn(executed_test) {
      case executed_test.outcome {
        Skipped -> Ok(executed_test.test_case)
        Passed | Failed(_) -> Error(Nil)
      }
    })
  let failed_tests =
    executed_tests
    |> list.filter_map(fn(executed_test) {
      case executed_test.outcome {
        Failed(failure) -> Ok(#(executed_test.test_case, failure))
        Passed | Skipped -> Error(Nil)
      }
    })
  reporter.report_summary(
    ctx,
    test_files,
    executed_tests,
    skipped_tests,
    failed_tests,
    discovery_duration,
    execution_duration,
    reporting_duration,
  )

  let exit_code = case list.is_empty(failed_tests) {
    True -> 0
    False -> 1
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
