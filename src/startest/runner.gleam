import gleam/int
import gleam/io
import gleam/list
import startest/internal/process
import startest/reporter.{type Reporter}
import startest/test_case.{
  type Test, type TestOutcome, ExecutedTest, Failed, Passed, Skipped,
}
import startest/test_failure
import startest/test_tree.{type TestTree}

pub fn run_tests(tests: List(TestTree), reporters: List(Reporter)) {
  let tests =
    tests
    |> list.flat_map(fn(tree) { test_tree.all_tests(tree) })

  let test_count = list.length(tests)
  io.println("Running " <> int.to_string(test_count) <> " tests")

  let executed_tests =
    tests
    |> list.map(fn(pair) {
      let test_case =
        test_case.Test(pair.0, { pair.1 }.body, { pair.1 }.skipped)

      ExecutedTest(test_case, run_test(test_case))
    })

  reporters
  |> list.each(fn(reporter) {
    executed_tests
    |> list.each(fn(executed_test) { reporter.report(executed_test) })

    reporter.finished()
  })

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
      case test_failure.rescue(test_case.body) {
        Ok(Nil) -> Passed
        Error(err) -> Failed(err)
      }
    }
  }
}
