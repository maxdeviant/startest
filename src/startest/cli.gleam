//// The Startest command line interface (CLI).

import argv
import gleam/option.{None, Some}
import glint
import glint/flag
import startest/config.{type Config}
import startest/runner
import startest/test_tree.{type TestTree}

/// Runs the Startest CLI.
pub fn run(tests: List(TestTree), config: Config) {
  glint.new()
  |> glint.with_name("Startest")
  |> glint.with_pretty_help(glint.default_pretty_help())
  |> glint.add(
    at: [],
    do: glint.command(fn(input: glint.CommandInput) {
      let assert Ok(filter) =
        flag.get_string(from: input.flags, for: test_name_filter)

      let config =
        config
        |> config.with_test_name_pattern(case filter {
          "" -> None
          filter -> Some(filter)
        })

      runner.run_tests(tests, config)
    })
      |> glint.flag(test_name_filter, test_name_filter_flag()),
  )
  |> glint.run(argv.load().arguments)
}

const test_name_filter = "filter"

fn test_name_filter_flag() -> flag.FlagBuilder(String) {
  flag.string()
  |> flag.default("")
  |> flag.description(
    "Filter down tests just to those whose names match the filter",
  )
}
