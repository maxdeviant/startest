# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/maxdeviant/startest/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/maxdeviant/startest/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/maxdeviant/startest/compare/6e7e1f2...v0.1.0
