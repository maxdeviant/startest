//// Assertions to be used in tests.

import exception
import gleam/float
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import startest/assertion_error.{AssertionError}

/// Asserts that the given value is equal to the expected value.
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

/// Asserts that the given value is not equal to the expected value.
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

/// Asserts that the given value is `True`.
pub fn to_be_true(actual: Bool) -> Nil {
  actual
  |> to_equal(True)
}

/// Asserts that the given value is `False`.
pub fn to_be_false(actual: Bool) -> Nil {
  actual
  |> to_equal(False)
}

/// Asserts that the given value is `Ok(_)`.
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

/// Asserts that the given value is `Error(_)`.
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

/// Asserts that the given value is `Some(_)`.
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

/// Asserts that the given value is `None`.
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

/// Asserts that the given string is neither empty nor consists only of
/// whitespace characters.
pub fn string_to_not_be_blank(actual: String) -> Nil {
  case actual |> string.trim() |> string.is_empty() {
    False -> Nil
    True ->
      AssertionError(
        string.concat(["Expected ", string.inspect(actual), " to not be blank"]),
        string.inspect(actual),
        "non-empty or non-whitespace-only string",
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given string contains the expected string.
pub fn string_to_contain(actual: String, expected: String) -> Nil {
  case string.contains(does: actual, contain: expected) {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to contain ",
          string.inspect(expected),
        ]),
        actual,
        expected,
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given string does not contain the expected string.
pub fn string_to_not_contain(actual: String, expected: String) -> Nil {
  case string.contains(does: actual, contain: expected) {
    False -> Nil
    True ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to not contain ",
          string.inspect(expected),
        ]),
        actual,
        expected,
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given string starts with the expected string.
pub fn string_to_start_with(actual: String, expected: String) -> Nil {
  case string.starts_with(actual, expected) {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to start with ",
          string.inspect(expected),
        ]),
        actual,
        expected,
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given string ends with the expected string.
pub fn string_to_end_with(actual: String, expected: String) -> Nil {
  case string.ends_with(actual, expected) {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to end with ",
          string.inspect(expected),
        ]),
        actual,
        expected,
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given list contains the expected element.
pub fn list_to_contain(actual: List(a), expected: a) -> Nil {
  case list.contains(actual, expected) {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to contain ",
          string.inspect(expected),
        ]),
        string.inspect(actual),
        string.inspect(expected),
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given list does not contain the expected element.
pub fn list_to_not_contain(actual: List(a), expected: a) -> Nil {
  case list.contains(actual, expected) {
    False -> Nil
    True ->
      AssertionError(
        string.concat([
          "Expected ",
          string.inspect(actual),
          " to not contain ",
          string.inspect(expected),
        ]),
        string.inspect(actual),
        string.inspect(expected),
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given function throws an error.
pub fn to_throw(f: fn() -> a) -> Nil {
  case exception.rescue(f) {
    Error(_) -> Nil
    Ok(value) ->
      AssertionError(
        string.concat(["Expected ", string.inspect(f), " to throw an error"]),
        string.inspect(value),
        string.inspect(Nil),
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given function does not throw an error.
pub fn to_not_throw(f: fn() -> a) -> a {
  case exception.rescue(f) {
    Ok(value) -> value
    Error(exception) ->
      AssertionError(
        string.concat(["Expected ", string.inspect(f), " to not throw an error"]),
        string.inspect(Nil),
        string.inspect(exception),
      )
      |> assertion_error.raise
  }
}

/// Asserts that the given `Float` is equal to the expected `Float` within the
/// provided tolerance.
pub fn to_loosely_equal(
  actual: Float,
  expected expected: Float,
  tolerating tolerance: Float,
) -> Nil {
  case float.loosely_equals(actual, expected, tolerance) {
    True -> Nil
    False ->
      AssertionError(
        string.concat([
          "Expected ",
          format_float(actual),
          " to loosely equal ",
          format_float(expected),
          " with a tolerance of ",
          format_float(tolerance),
        ]),
        format_float(actual),
        format_float(expected) <> " ± " <> format_float(tolerance),
      )
      |> assertion_error.raise
  }
}

/// Formats a `Float` value as a `String` in a way that is consistent
/// across targets.
fn format_float(value: Float) -> String {
  let repr = float.to_string(value)
  case string.contains(repr, ".") {
    True -> repr
    False -> repr <> ".0"
  }
}
