import gleam/option.{None, Some}
import startest.{describe}
import startest/expect
import test_helpers.{it_fails, it_fails_matching_snapshot, it_passes}

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
        it_fails_matching_snapshot(
          "expect/to_equal with two different integers",
          fn() {
            2
            |> expect.to_equal(4)
          },
        ),
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
        it_fails_matching_snapshot(
          "expect/to_not_equal with two equal integers",
          fn() {
            3
            |> expect.to_not_equal(3)
          },
        ),
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
        it_fails_matching_snapshot("expect/to_be_true given False", fn() {
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
        it_fails_matching_snapshot("expect/to_be_false given True", fn() {
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
        it_fails_matching_snapshot("expect/to_be_ok given an Error", fn() {
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
        it_fails_matching_snapshot("expect/to_be_error given an Ok", fn() {
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
        it_fails_matching_snapshot("expect/to_be_some given a None", fn() {
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
        it_fails_matching_snapshot("expect/to_be_none given a Some", fn() {
          Some(Nil)
          |> expect.to_be_none
        }),
      ]),
    ]),
  ])
}

pub fn string_to_contain_tests() {
  describe("startest/expect", [
    describe("string_to_contain", [
      describe("given a string that contains the expected pattern", [
        it_passes(fn() {
          "Scarecrow"
          |> expect.string_to_contain("care")
        }),
      ]),
      describe("given a string that does contain the expected pattern", [
        it_fails_matching_snapshot(
          "expect/string_to_contain given non-matching string",
          fn() {
            "Stupendous"
            |> expect.string_to_contain("apend")
          },
        ),
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

pub fn to_loosely_equal_tests() {
  describe("startest/expect", [
    describe("to_loosely_equal", [
      describe("given two loosely equal floats", [
        it_passes(fn() {
          2.0
          |> expect.to_loosely_equal(2.4, tolerating: 0.5)
        }),
      ]),
      describe("given two loosely inequal floats", [
        it_fails_matching_snapshot("expect/to_loosely_equal", fn() {
          2.0
          |> expect.to_loosely_equal(2.4, tolerating: 0.1)
        }),
      ]),
    ]),
  ])
}
