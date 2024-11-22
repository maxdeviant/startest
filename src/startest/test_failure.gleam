import exception.{type Exception}
import gleam/dict
import gleam/dynamic
import gleam/result.{try}
import gleam/string
import startest/assertion_error.{
  type RescuedAssertionError, RescuedAssertionError,
}

pub type TestFailure {
  AssertionError(RescuedAssertionError)
  GenericError(Exception)
}

pub fn rescue(f: fn() -> Nil) -> Result(Nil, TestFailure) {
  case exception.rescue(f) {
    Ok(Nil) -> Ok(Nil)
    Error(exception) -> {
      let panic_info =
        exception
        |> try_decode_panic_info
      case panic_info {
        Ok(panic_info) ->
          Error(AssertionError(RescuedAssertionError(panic_info.message)))
        Error(Nil) -> Error(GenericError(exception))
      }
    }
  }
}

pub fn to_string(failure: TestFailure) -> String {
  case failure {
    AssertionError(assertion_error) -> assertion_error.message
    GenericError(exception) -> string.inspect(exception)
  }
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

fn try_decode_panic_info(exception: Exception) -> Result(PanicInfo, Nil) {
  let err = case exception {
    exception.Errored(err) | exception.Thrown(err) | exception.Exited(err) ->
      err
  }

  case dynamic.classify(err) {
    "Dict" -> {
      use dict <- try(
        err
        |> dynamic.dict(dynamic.dynamic, dynamic.dynamic)
        |> result.replace_error(Nil),
      )

      use module <- try(
        dict
        |> dict.get(dynamic.from(Module))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.replace_error(Nil)
        }),
      )
      use function <- try(
        dict
        |> dict.get(dynamic.from(Function))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.replace_error(Nil)
        }),
      )
      use line <- try(
        dict
        |> dict.get(dynamic.from(Line))
        |> result.then(fn(value) {
          value
          |> dynamic.int
          |> result.replace_error(Nil)
        }),
      )
      use message <- try(
        dict
        |> dict.get(dynamic.from(Message))
        |> result.then(fn(value) {
          value
          |> dynamic.string
          |> result.replace_error(Nil)
        }),
      )

      Ok(PanicInfo(module, function, line, message))
    }
    "Object" -> {
      use module <- try(
        err
        |> dynamic.field("module", dynamic.string)
        |> result.replace_error(Nil),
      )
      use function <- try(
        err
        |> dynamic.field("fn", dynamic.string)
        |> result.replace_error(Nil),
      )
      use line <- try(
        err
        |> dynamic.field("line", dynamic.int)
        |> result.replace_error(Nil),
      )
      use message <- try(
        err
        |> dynamic.field("message", dynamic.string)
        |> result.replace_error(Nil),
      )

      Ok(PanicInfo(module, function, line, message))
    }
    _ -> Error(Nil)
  }
}
