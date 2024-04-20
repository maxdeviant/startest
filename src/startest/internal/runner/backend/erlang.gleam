//// The test runner implementation specific to the Erlang target.

@target(erlang)
import startest/context.{type Context}
@target(erlang)
import startest/internal/runner/core
@target(erlang)
import startest/test_tree.{type TestTree}

@target(erlang)
pub fn run_tests(ctx: Context, tests: List(TestTree)) -> Nil {
  core.run_tests(ctx, tests)
}
