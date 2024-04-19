import exception.{type Exception}
import gleam/dict
import gleam/dynamic
import gleam/io
import gleam/result.{try}
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
        let error_message = case try_decode(err) {
          Ok(err) -> err.message
          Error(Nil) -> string.inspect(err)
        }

        io.println(
          ansi.red("×") <> " " <> test_case.name <> ": " <> error_message,
        )
      }
      Skipped -> io.println(ansi.gray("~") <> " " <> test_case.name)
    }
  })
}

type PanicInfo {
  PanicInfo(module: String, function: String, line: Int, message: String)
}

type PanicKey {
  Module
  Function
  Message
  Line
}

fn try_decode(exception: Exception) {
  let err = case exception {
    exception.Errored(err) | exception.Thrown(err) | exception.Exited(err) ->
      err
  }

  case dynamic.classify(err) {
    "Dict" -> {
      use dict <- try(
        err
        |> dynamic.dict(dynamic.dynamic, dynamic.dynamic)
        |> result.nil_error,
      )

      use module <- try(
        dict
        |> dict.get(dynamic.from(Module))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.nil_error
        }),
      )
      use function <- try(
        dict
        |> dict.get(dynamic.from(Function))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.nil_error
        }),
      )
      use line <- try(
        dict
        |> dict.get(dynamic.from(Line))
        |> result.then(fn(value) {
          value
          |> dynamic.int
          |> result.nil_error
        }),
      )
      use message <- try(
        dict
        |> dict.get(dynamic.from(Message))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.nil_error
        }),
      )

      Ok(PanicInfo(module, function, line, message))
    }
    "Object" -> {
      use module <- try(
        err
        |> dynamic.field("module", dynamic.string)
        |> result.nil_error,
      )
      use function <- try(
        err
        |> dynamic.field("fn", dynamic.string)
        |> result.nil_error,
      )
      use line <- try(
        err
        |> dynamic.field("line", dynamic.int)
        |> result.nil_error,
      )
      use message <- try(
        err
        |> dynamic.field("message", dynamic.string)
        |> result.nil_error,
      )

      Ok(PanicInfo(module, function, line, message))
    }
    _ -> Error(Nil)
  }
}
