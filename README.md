# startest

[![Package Version](https://img.shields.io/hexpm/v/startest)](https://hex.pm/packages/startest)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/startest/)

🌠 A testing framework to help you shoot for the stars.

## Installation

```sh
gleam add --dev startest
```

## Usage

```gleam
import startest.{describe, it}
import startest/expect

// Inside of `test/my_project_test.gleam`:
pub fn main() {
  // Call `startest.run` inside of your `main` function.
  // Here we're using the default config, but you can customize this, as needed.
  startest.run(startest.default_config())
}

// Tests can be expressed using the `describe` API:
pub fn my_project_tests() {
  describe("My Project", [
    describe("2 + 2", [
      it("equals 4", fn() {
        2 + 2
        |> expect.to_equal(4)
      }),
    ]),
  ])
}

// You can also write tests as standalone functions.
// These functions must be public and have a name ending in `_test`:
pub fn a_standalone_test() {
  { "Hello, " <> "Joe!" }
  |> expect.to_equal("Hello, Joe!")
}
```

## Targets

`startest` supports both targets: Erlang and JavaScript.
