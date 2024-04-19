import exception
import gleam/int
import gleam/io
import gleam/list
import startest/internal/process
import startest/reporters/default as default_reporter
import startest/test_case.{
  type Test, type TestOutcome, ExecutedTest, Failed, Passed, Skipped,
}

pub fn run_tests(tests: List(Test)) {
  let test_count = list.length(tests)
  io.println("Running " <> int.to_string(test_count) <> " tests")

  let reporter = default_reporter.new()

  let executed_tests =
    tests
    |> list.map(fn(test_case) { ExecutedTest(test_case, run_test(test_case)) })

  executed_tests
  |> list.each(fn(executed_test) { reporter.report(executed_test) })

  let has_any_failures =
    executed_tests
    |> list.any(fn(executed_test) { test_case.is_failed(executed_test) })

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
      let result = exception.rescue(test_case.body)
      case result {
        Ok(Nil) -> Passed
        Error(err) -> Failed(err)
      }
    }
  }
}
