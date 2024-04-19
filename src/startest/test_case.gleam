import exception.{type Exception}

/// A test case.
pub type Test {
  Test(name: String, body: fn() -> Nil, skipped: Bool)
}

/// The outcome of a `Test` that has been run.
pub type TestOutcome {
  Passed
  Failed(exception: Exception)
  Skipped
}

/// A `Test` that has been executed and has a `TestOutcome`.
pub type ExecutedTest {
  ExecutedTest(test_case: Test, outcome: TestOutcome)
}

pub fn is_failed(executed_test: ExecutedTest) -> Bool {
  case executed_test.outcome {
    Failed(_) -> True
    Passed | Skipped -> False
  }
}
