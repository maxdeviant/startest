import gleam/option.{type Option, None, Some}
import gleam/string
import gleam_community/ansi

const blank_line = "\n\n"

pub fn to_equal(actual: a, expected expected: a) -> Nil {
  case actual == expected {
    True -> Nil
    False ->
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to equal ",
        string.inspect(expected),
        blank_line,
        show_diff(string.inspect(actual), string.inspect(expected)),
      ])
  }
}

pub fn to_not_equal(actual: a, expected expected: a) -> Nil {
  case actual != expected {
    True -> Nil
    False ->
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to not equal ",
        string.inspect(expected),
        blank_line,
        show_diff(string.inspect(actual), string.inspect(expected)),
      ])
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
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to be Ok",
        blank_line,
        show_diff(string.inspect(actual), "Ok(_)"),
      ])
  }
}

pub fn to_be_error(actual: Result(a, err)) -> err {
  case actual {
    Error(error) -> error
    Ok(_) ->
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to be Error",
        blank_line,
        show_diff(string.inspect(actual), "Error(_)"),
      ])
  }
}

pub fn to_be_some(actual: Option(a)) -> a {
  case actual {
    Some(value) -> value
    None ->
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to be Some",
        blank_line,
        show_diff(string.inspect(actual), "Some(_)"),
      ])
  }
}

pub fn to_be_none(actual: Option(a)) -> Nil {
  case actual {
    None -> Nil
    Some(_) ->
      panic as string.concat([
        "Expected ",
        string.inspect(actual),
        " to be None",
        blank_line,
        show_diff(string.inspect(actual), "None"),
      ])
  }
}

fn show_diff(actual: String, expected: String) -> String {
  string.concat([
    ansi.green("- Expected"),
    "\n",
    ansi.red("+ Received"),
    "\n\n",
    ansi.green("- " <> expected),
    "\n",
    ansi.red("+ " <> actual),
  ])
}
