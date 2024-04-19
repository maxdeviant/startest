import startest/runner
import startest/test_case.{type Test, Test}

pub fn it(name: String, body: fn() -> Nil) -> Test {
  Test(name, body, False)
}

pub fn xit(name: String, _body: fn() -> Nil) -> Test {
  Test(name, fn() { Nil }, True)
}

pub fn run_tests(tests: List(Test)) -> Nil {
  runner.run_tests(tests)
}
