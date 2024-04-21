//// The Startest command line interface (CLI).

import argv
import gleam/option.{None, Some}
import glint
import startest/config.{type Config}
import startest/context.{Context}
import startest/internal/runner
import startest/logger.{Logger}

/// Runs the Startest CLI.
pub fn run(config: Config) {
  glint.new()
  |> glint.name("gleam test --")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: {
    use test_name_filter <- glint.flag(
      "filter",
      glint.string()
        |> glint.default("")
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

      let ctx = Context(config, logger: Logger)

      runner.run_tests(ctx)
    })
  })
  |> glint.run(argv.load().arguments)
}
