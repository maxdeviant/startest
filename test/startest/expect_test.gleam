import gleam/option.{None, Some}
import startest.{describe}
import startest/expect
import test_helpers.{it_fails, it_passes}

pub fn to_equal_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_not_equal_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_true_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_false_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_ok_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_error_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_some_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_be_none_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_throw_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}

pub fn to_not_throw_tests() {
  describe("startest/expect", [
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
    ]),
  ])
}
