import startest.{describe, it}
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

pub fn suite() {
  describe("startest/expect", [
    to_equal_tests(),
    to_be_ok_tests(),
    to_be_error_tests(),
    to_throw_tests(),
  ])
}

fn to_equal_tests() {
  describe("to_equal", [
    describe("given two equal integers", [
      it_passes(fn() {
        2
        |> expect.to_equal(2)
      }),
    ]),
    describe("given two different intergers", [
      it_fails(fn() {
        2
        |> expect.to_equal(4)
      }),
    ]),
  ])
}

fn to_be_ok_tests() {
  describe("to_be_ok", [
    describe("given an Ok", [
      it_passes(fn() {
        Ok(Nil)
        |> expect.to_be_ok
      }),
    ]),
    describe("given an Error", [
      it_fails(fn() {
        Error(Nil)
        |> expect.to_be_ok
      }),
    ]),
  ])
}

fn to_be_error_tests() {
  describe("to_be_error", [
    describe("given an Error", [
      it_passes(fn() {
        Error(Nil)
        |> expect.to_be_error
      }),
    ]),
    describe("given an Ok", [
      it_fails(fn() {
        Ok(Nil)
        |> expect.to_be_error
      }),
    ]),
  ])
}

fn to_throw_tests() {
  describe("to_throw", [
    describe("given a function that panics", [
      it_passes(fn() {
        fn() { panic as "uh oh" }
        |> expect.to_throw
      }),
    ]),
    describe("given a function that does not panic", [
      it_fails(fn() {
        fn() { "all good" }
        |> expect.to_throw
      }),
    ]),
  ])
}
