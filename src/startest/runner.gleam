import gleam/int
import gleam/io
import gleam/list
import gleam_community/ansi
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
