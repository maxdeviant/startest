# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.1] - 2024-11-21

### Changed

- Upgraded `tom` to v1.1.0.

## [0.5.0] - 2024-07-31

### Added

- Added `expect/string_to_not_start_with` for asserting that a string does not start with another string.
- Added `expect/string_to_not_end_with` for asserting that a string does not end with another string.

### Changed

- Upgraded `simplifile` to v2.0.1.

## [0.4.0] - 2024-06-14

### Added

- Added skipped test count to the test summary.

## [0.3.0] - 2024-06-11

### Added

- Added `expect/string_to_contain` for asserting that a string contains another string.
- Added `expect/string_to_not_contain` for asserting that a string does not contain another string.
- Added `expect/string_to_start_with` for asserting that a string starts with another string.
- Added `expect/string_to_end_with` for asserting that a string ends with another string.
- Added `expect/list_to_contain` for asserting that a list contains a given element.
- Added `expect/list_to_not_contain` for asserting that a list does not contain a given element.

### Changed

- Fixed warnings with `gleam_stdlib` v0.38.0.

## [0.2.4] - 2024-05-18

### Changed

- Upgraded `glint` to v1.0.0-rc2.

## [0.2.3] - 2024-05-13

### Added

- Added `expect/to_loosely_equal` for asserting on `Float` values.

## [0.2.2] - 2024-05-06

### Changed

- Pinned `glint` to v1.0.0-rc1.

## [0.2.1] - 2024-04-27

### Added

- Added test filtering using positional arguments to the CLI.
  - You can provide zero or more test filepaths for filtering.
  - `gleam test -- example` will run all tests in files that have "example" in their name.
  - `gleam test -- test/startest_test.gleam` will run just the tests in the specified file.

### Changed

- Renamed `--filter` CLI flag to `--test-name-filter`.

## [0.2.0] - 2024-04-20

### Added

- Added `startest.run` for running tests.
  - `startest.run` takes a `Config` and will auto-discover and run the tests.
- Added Startest CLI
  - Calling `startest.run` in your test `main` will allow you to use the CLI via `gleam test`.
- Added dot reporter.
- Added a `finished` callback to `Reporter`.

### Changed

- Changed `Reporter.report` to take a `ReporterContext` as the first argument.

### Removed

- Removed `startest.run_tests` in favor of `startest.run`.

## [0.1.0] - 2024-04-19

- Initial release.

[unreleased]: https://github.com/maxdeviant/startest/compare/v0.5.1...HEAD
[0.5.1]: https://github.com/maxdeviant/startest/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/maxdeviant/startest/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/maxdeviant/startest/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/maxdeviant/startest/compare/v0.2.4...v0.3.0
[0.2.4]: https://github.com/maxdeviant/startest/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/maxdeviant/startest/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/maxdeviant/startest/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/maxdeviant/startest/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/maxdeviant/startest/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/maxdeviant/startest/compare/6e7e1f2...v0.1.0
