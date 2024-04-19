import gleam/string
import gleam_community/ansi

pub fn to_equal(actual: a, expected expected: a) -> Nil {
  case actual == expected {
    True -> Nil
    False ->
      panic as string.concat([
        "Expected ",
        string.inspect(expected),
        " to equal ",
        string.inspect(actual),
        "\n\n",
        ansi.green("- Expected"),
        "\n",
        ansi.red("+ Received"),
        "\n\n",
        ansi.green("- " <> string.inspect(expected)),
        "\n",
        ansi.red("+ " <> string.inspect(actual)),
      ])
  }
}
