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
import startest/config
import startest/expect

pub fn main() {
  [
    describe("My Project", [
      describe("2 + 2", [
        it("equals 4", fn() {
          2 + 2
          |> expect.to_equal(4)
        }),
      ]),
    ]),
  ]
  |> startest.run(config.default())
}
```

## Targets

`startest` supports both targets: Erlang and JavaScript.
