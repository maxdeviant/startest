import gleam/io
import gleam/string
import startest/reporter.{type Reporter, Reporter}
import startest/test_case.{Failed, Passed, Skipped}

pub fn new() -> Reporter {
  Reporter(fn(executed_test) {
    let test_case = executed_test.test_case

    case executed_test.outcome {
      Passed -> io.println("✅ " <> test_case.name)
      Failed(err) -> {
        io.println("❌ " <> test_case.name <> ": " <> string.inspect(err))
      }
      Skipped -> io.println("~ " <> test_case.name)
    }
  })
}
