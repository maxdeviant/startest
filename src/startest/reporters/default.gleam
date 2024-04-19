import gleam/io
import gleam/string
import gleam_community/ansi
import startest/reporter.{type Reporter, Reporter}
import startest/test_case.{Failed, Passed, Skipped}

pub fn new() -> Reporter {
  Reporter(fn(executed_test) {
    let test_case = executed_test.test_case

    case executed_test.outcome {
      Passed -> io.println(ansi.green("✓") <> " " <> test_case.name)
      Failed(err) -> {
        io.println(
          ansi.red("×") <> " " <> test_case.name <> ": " <> string.inspect(err),
        )
      }
      Skipped -> io.println(ansi.gray("~") <> " " <> test_case.name)
    }
  })
}
