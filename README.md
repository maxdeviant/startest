# startest

[![Package Version](https://img.shields.io/hexpm/v/startest)](https://hex.pm/packages/startest)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/startest/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

🌠 A testing framework to help you shoot for the stars.

## Installation

```sh
gleam add --dev startest
```

## Features

- Write tests using the `describe` API or as standalone functions
- Filter tests by file path or test name
- Pretty assertions from `expect` matchers

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

## Migrating from gleeunit

If you're coming from [`gleeunit`](https://hexdocs.pm/gleeunit), follow these steps for an easy migration to Startest:

1. Install Startest with `gleam add --dev startest`
1. Replace all imports of `gleeunit/should` with `startest/expect`
1. Update `gleeunit/should` assertions to `startest/expect`
   - Consult the migration table down below for the equivalent assertions in Startest
1. Remove `gleeunit` with `gleam remove gleeunit`
1. Optionally, begin using the `describe` API to structure your tests

| `gleeunit/should`  | `startest/expect`                     |
| ------------------ | ------------------------------------- |
| `should.equal`     | `expect.to_equal`                     |
| `should.not_equal` | `expect.to_not_equal`                 |
| `should.be_true`   | `expect.to_be_true`                   |
| `should.be_false`  | `expect.to_be_false`                  |
| `should.be_ok`     | `expect.to_be_ok`                     |
| `should.be_error`  | `expect.to_be_error`                  |
| `should.be_some`   | `expect.to_be_some`                   |
| `should.be_none`   | `expect.to_be_none`                   |
| `should.fail`      | `expect.to_be_true(False)` or `panic` |

This conversion can typically be done with a find/replace:

```diff
- should.
+ expect.to_
```
