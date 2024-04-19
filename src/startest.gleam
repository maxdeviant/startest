import exception
import gleam/int
import gleam/io
import gleam/list
import startest/internal/process

pub opaque type TestCase {
  TestCase(name: String, body: fn() -> Nil, skipped: Bool)
}

type TestOutcome {
  Passed
  Failed
  Skipped
}

pub fn it(name: String, body: fn() -> Nil) -> TestCase {
  TestCase(name, body, False)
}

pub fn xit(name: String, _body: fn() -> Nil) -> TestCase {
  TestCase(name, fn() { Nil }, True)
}

pub fn run_tests(tests: List(TestCase)) {
  let test_count = list.length(tests)
  io.println("Running " <> int.to_string(test_count) <> " tests")

  let test_results =
    tests
    |> list.map(fn(test_case) { run_test(test_case) })

  let has_any_failures =
    test_results
    |> list.any(fn(outcome) { outcome == Failed })

  let exit_code = case has_any_failures {
    True -> 1
    False -> 0
  }

  process.exit(exit_code)
}

fn run_test(test_case: TestCase) -> TestOutcome {
  case test_case.skipped {
    True -> {
      io.println("~ " <> test_case.name)
      Skipped
    }
    False -> {
      let result = exception.rescue(test_case.body)
      case result {
        Ok(Nil) -> {
          io.println("✅ " <> test_case.name)
          Passed
        }
        Error(err) -> {
          io.print("❌ " <> test_case.name <> ": ")
          io.debug(err)
          Failed
        }
      }
    }
  }
}
