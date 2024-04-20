import gleam/list
import gleam/result.{try}
import gleam/string
import simplifile

/// Returns the list of files in the `test/` directory.
pub fn locate_test_files() -> Result(List(String), Nil) {
  use test_files <- try(
    simplifile.get_files(in: "test")
    |> result.nil_error,
  )

  let gleam_test_files =
    test_files
    |> list.filter(fn(filename) { string.ends_with(filename, ".gleam") })

  Ok(gleam_test_files)
}
