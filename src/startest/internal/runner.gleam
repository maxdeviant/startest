@target(javascript)
import gleam/javascript/promise.{type Promise}
import startest/context.{type Context}
@target(erlang)
import startest/internal/runner/backend/erlang as erlang_runner
@target(javascript)
import startest/internal/runner/backend/javascript as javascript_runner

@target(erlang)
pub fn run_tests(ctx: Context) -> Nil {
  erlang_runner.run_tests(ctx)
}

@target(javascript)
pub fn run_tests(ctx: Context) -> Nil {
  do_run_tests(ctx, javascript_runner.run_tests)
}

@target(javascript)
@external(javascript, "../../startest_ffi.mjs", "do_run_tests")
fn do_run_tests(ctx: Context, run: fn(Context) -> Promise(Nil)) -> Nil
