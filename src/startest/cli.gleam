//// The Startest command line interface (CLI).

import argv
import bigben/clock
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import gleam_community/ansi
import glint
import startest/config.{type Config}
import startest/context.{Context}
import startest/internal/gleam_toml
import startest/internal/runner
import startest/logger.{Logger}

/// Runs the Startest CLI.
pub fn run(config: Config) {
  glint.new()
  |> glint.with_name("gleam test --")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: {
    let package_name =
      gleam_toml.read_name()
      |> result.unwrap("my_project")

    use <- glint.command_help(
      string.concat([
        "Runs the tests.",
        "\n\n",
        "Accepts zero or more filepath patterns as `ARGS` to filter down which tests are run. For example:",
        "\n\n",
        "  - `",
        ansi.cyan("gleam test -- example"),
        "` will run the tests in all files that have \"example\" in their name",
        "\n",
        "  - `",
        ansi.cyan("gleam test -- test/" <> package_name <> "_test.gleam"),
        "` will run just the tests in that specific file",
      ]),
    )
    use test_name_filter <- glint.flag(
      glint.string_flag("test-name-filter")
      |> glint.flag_default("")
      |> glint.flag_help(
        "Filter down tests just to those whose names match the filter",
      ),
    )

    glint.command(fn(_named_args, args, flags) {
      let filters = args

      let assert Ok(filter) = test_name_filter(flags)

      let config =
        config
        |> config.with_filters(filters)
        |> config.with_test_name_pattern(case filter {
          "" -> None
          filter -> Some(filter)
        })

      let clock = clock.new()

      let ctx =
        Context(
          config,
          clock: clock,
          logger: Logger,
          started_at: clock.now(clock),
        )

      runner.run_tests(ctx)
    })
  })
  |> glint.run(argv.load().arguments)
}
