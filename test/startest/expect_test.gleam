import gleam/option.{None, Some}
import startest.{describe}
import startest/expect
import test_helpers.{it_fails, it_passes}

pub fn suite() {
  describe("startest/expect", [
    to_equal_tests(),
    to_not_equal_tests(),
    to_be_true_tests(),
    to_be_false_tests(),
    to_be_ok_tests(),
    to_be_error_tests(),
    to_be_some_tests(),
    to_be_none_tests(),
    to_throw_tests(),
    to_not_throw_tests(),
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
    describe("given two different integers", [
      it_fails(fn() {
        2
        |> expect.to_equal(4)
      }),
    ]),
  ])
}

fn to_not_equal_tests() {
  describe("to_not_equal", [
    describe("given two different integers", [
      it_passes(fn() {
        3
        |> expect.to_not_equal(5)
      }),
    ]),
    describe("given two equal integers", [
      it_fails(fn() {
        3
        |> expect.to_not_equal(3)
      }),
    ]),
  ])
}

fn to_be_true_tests() {
  describe("to_be_true", [
    describe("given True", [
      it_passes(fn() {
        True
        |> expect.to_be_true
      }),
    ]),
    describe("given False", [
      it_fails(fn() {
        False
        |> expect.to_be_true
      }),
    ]),
  ])
}

fn to_be_false_tests() {
  describe("to_be_false", [
    describe("given False", [
      it_passes(fn() {
        False
        |> expect.to_be_false
      }),
    ]),
    describe("given True", [
      it_fails(fn() {
        True
        |> expect.to_be_false
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

fn to_be_some_tests() {
  describe("to_be_some", [
    describe("given a Some", [
      it_passes(fn() {
        Some(Nil)
        |> expect.to_be_some
      }),
    ]),
    describe("given a None", [
      it_fails(fn() {
        None
        |> expect.to_be_some
      }),
    ]),
  ])
}

fn to_be_none_tests() {
  describe("to_be_none", [
    describe("given a None", [
      it_passes(fn() {
        None
        |> expect.to_be_none
      }),
    ]),
    describe("given a Some", [
      it_fails(fn() {
        Some(Nil)
        |> expect.to_be_none
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
        fn() { Nil }
        |> expect.to_throw
      }),
    ]),
  ])
}

fn to_not_throw_tests() {
  describe("to_not_throw", [
    describe("given a function that does not panic", [
      it_passes(fn() {
        fn() { Nil }
        |> expect.to_not_throw
      }),
    ]),
    describe("given a function that panics", [
      it_fails(fn() {
        fn() { panic as "uh oh" }
        |> expect.to_not_throw
      }),
    ]),
  ])
}
