import gleam/string
import gleam_community/ansi

pub type AssertionError {
  AssertionError(message: String, actual: String, expected: String)
}

pub type RescuedAssertionError {
  RescuedAssertionError(message: String)
}

/// Raises an `AssertionError`.
///
/// Intended for use by matchers to cause a test to fail.
pub fn raise(error: AssertionError) -> a {
  let blank_line = "\n\n"

  panic as string.concat([
    error.message,
    blank_line,
    show_diff(error.actual, error.expected),
  ])
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
