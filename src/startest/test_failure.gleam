import exception.{type Exception}
import gleam/dict
import gleam/dynamic
import gleam/dynamic/decode
import gleam/result.{try}
import gleam/string
import startest/assertion_error.{
  type RescuedAssertionError, RescuedAssertionError,
}
import startest/internal/unsafe

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
        |> decode.run(decode.dict(decode.dynamic, decode.dynamic))
        |> result.replace_error(Nil),
      )

      use module <- try(
        dict
        |> dict.get(unsafe.from(Module))
        |> result.try(fn(value) {
          value
          |> decode.run(decode.string)
          |> result.replace_error(Nil)
        }),
      )
      use function <- try(
        dict
        |> dict.get(unsafe.from(Function))
        |> result.try(fn(value) {
          value
          |> decode.run(decode.string)
          |> result.replace_error(Nil)
        }),
      )
      use line <- try(
        dict
        |> dict.get(unsafe.from(Line))
        |> result.try(fn(value) {
          value
          |> decode.run(decode.int)
          |> result.replace_error(Nil)
        }),
      )
      use message <- try(
        dict
        |> dict.get(unsafe.from(Message))
        |> result.try(fn(value) {
          value
          |> decode.run(decode.string)
          |> result.replace_error(Nil)
        }),
      )

      Ok(PanicInfo(module, function, line, message))
    }
    "Object" -> {
      use module <- try(
        err
        |> decode.run(decode.field("module", decode.string, decode.success))
        |> result.replace_error(Nil),
      )
      use function <- try(
        err
        |> decode.run(decode.field("fn", decode.string, decode.success))
        |> result.replace_error(Nil),
      )
      use line <- try(
        err
        |> decode.run(decode.field("line", decode.int, decode.success))
        |> result.replace_error(Nil),
      )
      use message <- try(
        err
        |> decode.run(decode.field("message", decode.string, decode.success))
        |> result.replace_error(Nil),
      )

      Ok(PanicInfo(module, function, line, message))
    }
    _ -> Error(Nil)
  }
}
