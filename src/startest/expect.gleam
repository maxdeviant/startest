import gleam/option.{type Option, None, Some}
import gleam/string
import startest/assertion_error.{AssertionError}

pub fn to_equal(actual: a, expected expected: a) -> Nil {
  case actual == expected {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to equal ",
          string.inspect(expected),
        ]),
        string.inspect(actual),
        string.inspect(expected),
      )
      |> assertion_error.raise
  }
}

pub fn to_not_equal(actual: a, expected expected: a) -> Nil {
  case actual != expected {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to not equal ",
          string.inspect(expected),
        ]),
        string.inspect(actual),
        string.inspect(expected),
      )
      |> assertion_error.raise
  }
}

pub fn to_be_true(actual: Bool) -> Nil {
  actual
  |> to_equal(True)
}

pub fn to_be_false(actual: Bool) -> Nil {
  actual
  |> to_equal(False)
}

pub fn to_be_ok(actual: Result(a, err)) -> a {
  case actual {
    Ok(value) -> value
    Error(_) ->
      AssertionError(
        string.concat(["Expected ", string.inspect(actual), " to be Ok"]),
        string.inspect(actual),
        "Ok(_)",
      )
      |> assertion_error.raise
  }
}

pub fn to_be_error(actual: Result(a, err)) -> err {
  case actual {
    Error(error) -> error
    Ok(_) ->
      AssertionError(
        string.concat(["Expected ", string.inspect(actual), " to be Error"]),
        string.inspect(actual),
        "Error(_)",
      )
      |> assertion_error.raise
  }
}

pub fn to_be_some(actual: Option(a)) -> a {
  case actual {
    Some(value) -> value
    None ->
      AssertionError(
        string.concat(["Expected ", string.inspect(actual), " to be Some"]),
        string.inspect(actual),
        "Some(_)",
      )
      |> assertion_error.raise
  }
}

pub fn to_be_none(actual: Option(a)) -> Nil {
  case actual {
    None -> Nil
    Some(_) ->
      AssertionError(
        string.concat(["Expected ", string.inspect(actual), " to be None"]),
        string.inspect(actual),
        "None",
      )
      |> assertion_error.raise
  }
}
