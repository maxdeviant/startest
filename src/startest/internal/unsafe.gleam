import gleam/dynamic.{type Dynamic}

pub fn coerce(value: Dynamic) -> a {
  do_unsafe_coerce(value)
}

@external(erlang, "gleam_stdlib", "identity")
@external(javascript, "../../../gleam_stdlib/gleam_stdlib.mjs", "identity")
fn do_unsafe_coerce(a: Dynamic) -> a
