@target(javascript)
import gleam/javascript/promise.{type Promise}
import startest/context.{type Context}
@target(erlang)
import startest/internal/runner/backend/erlang as erlang_runner
@target(javascript)
import startest/internal/runner/backend/javascript as javascript_runner
import startest/test_tree.{type TestTree}

@target(erlang)
pub fn run_tests(ctx: Context, tests: List(TestTree)) -> Nil {
  erlang_runner.run_tests(ctx, tests)
}

@target(javascript)
pub fn run_tests(ctx: Context, tests: List(TestTree)) -> Nil {
  do_run_tests(ctx, tests, javascript_runner.run_tests)
}

@target(javascript)
@external(javascript, "../../startest_ffi.mjs", "do_run_tests")
fn do_run_tests(
  ctx: Context,
  tests: List(TestTree),
  run: fn(Context, List(TestTree)) -> Promise(Nil),
) -> Nil
