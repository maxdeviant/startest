import startest/test_failure.{type TestFailure}

/// A test case.
pub type Test {
  Test(name: String, body: fn() -> Nil, skipped: Bool)
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
