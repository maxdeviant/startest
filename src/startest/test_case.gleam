import gleam/dynamic.{type DecodeError, type Dynamic} as dyn
import startest/internal/unsafe
import startest/test_failure.{type TestFailure}

pub type TestBody =
  fn() -> Nil

/// A test case.
pub type Test {
  Test(name: String, body: TestBody, skipped: Bool)
}

/// The outcome of a `Test` that has been run.
pub type TestOutcome {
  Passed
  Failed(TestFailure)
  Skipped
}

/// A `Test` that has been executed and has a `TestOutcome`.
pub type ExecutedTest {
  ExecutedTest(test_case: Test, outcome: TestOutcome)
}

@target(erlang)
pub fn decode_test(value: Dynamic) -> Result(Test, List(DecodeError)) {
  value
  |> dyn.decode3(
    Test,
    dyn.element(1, dyn.string),
    dyn.element(2, decode_test_body),
    dyn.element(3, dyn.bool),
  )
}

@target(javascript)
pub fn decode_test(value: Dynamic) -> Result(Test, List(DecodeError)) {
  value
  |> dyn.decode3(
    Test,
    dyn.field("name", dyn.string),
    dyn.field("body", decode_test_body),
    dyn.field("skipped", dyn.bool),
  )
}

fn decode_test_body(value: Dynamic) -> Result(TestBody, List(DecodeError)) {
  let function: TestBody = unsafe.coerce(value)
  Ok(function)
}
