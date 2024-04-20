import gleam/io
import gleam_community/ansi
import startest/reporters.{type Reporter, Reporter}
import startest/test_case.{Failed, Passed, Skipped}

pub fn new() -> Reporter {
  Reporter(
    report: fn(executed_test) {
      let test_case = executed_test.test_case
      case executed_test.outcome {
        Passed -> io.println(ansi.green("✓") <> " " <> test_case.name)
        Failed(_failure) -> {
          io.println(ansi.red("×") <> " " <> test_case.name)
        }
        Skipped -> io.println(ansi.gray("~") <> " " <> test_case.name)
      }
    },
    finished: fn() { Nil },
  )
}
