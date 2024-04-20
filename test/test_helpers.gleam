//// Helper utilities for writing tests.

import startest.{it}
import startest/expect
import startest/test_tree.{type TestTree}

/// Returns a test that passes when the provided test function passes.
pub fn it_passes(test_fn: fn() -> Nil) -> TestTree {
  it("passes", fn() {
    test_fn
    |> expect.to_not_throw
  })
}

/// Returns a test that passes when the provided test function fails.
pub fn it_fails(test_fn: fn() -> Nil) -> TestTree {
  it("fails", fn() {
    test_fn
    |> expect.to_throw
  })
}
