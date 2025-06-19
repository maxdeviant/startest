import gleam/dynamic/decode
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
pub fn test_decoder() {
  use name <- decode.then(decode.at([1], decode.string))
  use body <- decode.then(decode.at([2], test_body_decoder()))
  use skipped <- decode.then(decode.at([3], decode.bool))
  decode.success(Test(name, body, skipped))
}

@target(javascript)
pub fn test_decoder() {
  use name <- decode.field("name", decode.string)
  use body <- decode.field("body", test_body_decoder())
  use skipped <- decode.field("skipped", decode.bool)
  decode.success(Test(name, body, skipped))
}

fn test_body_decoder() {
  decode.new_primitive_decoder("TestBody", fn(value) {
    let function: TestBody = unsafe.coerce(value)
    Ok(function)
  })
}
