//// Constructs for working with a `gleam.toml` file.

import gleam/result.{try}
import gleam/string
import simplifile
import tom

/// Reads the `name` out of the root `gleam.toml` for the package.
pub fn read_name() {
  use toml <- try(
    simplifile.read("gleam.toml")
    |> result.map_error(fn(err) {
      "Failed to read `gleam.toml`: " <> simplifile.describe_error(err)
    }),
  )
  use toml <- try(
    tom.parse(toml)
    |> result.map_error(fn(err) {
      "Failed to parse `gleam.toml`: " <> string.inspect(err)
    }),
  )

  toml
  |> tom.get_string(["name"])
  |> result.map_error(fn(err) {
    "Failed to read `name` from `gleam.toml`: " <> string.inspect(err)
  })
}
