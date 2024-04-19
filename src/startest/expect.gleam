import gleam/string
import gleam_community/ansi

const blank_line = "\n\n"

pub fn to_equal(actual: a, expected expected: a) -> Nil {
  case actual == expected {
    True -> Nil
    False ->
      panic as string.concat([
        "Expected ",
        string.inspect(expected),
        " to equal ",
        string.inspect(actual),
        blank_line,
        show_diff(actual, expected),
      ])
  }
}

pub fn to_not_equal(actual: a, expected expected: a) -> Nil {
  case actual != expected {
    True -> Nil
    False ->
      panic as string.concat([
        "Expected ",
        string.inspect(expected),
        " to not equal ",
        string.inspect(actual),
        blank_line,
        show_diff(actual, expected),
      ])
  }
}

fn show_diff(actual: a, expected: a) -> String {
  string.concat([
    ansi.green("- Expected"),
    "\n",
    ansi.red("+ Received"),
    "\n\n",
    ansi.green("- " <> string.inspect(expected)),
    "\n",
    ansi.red("+ " <> string.inspect(actual)),
  ])
}
