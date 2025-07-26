import gleam/dynamic.{type Dynamic}

pub fn coerce(value: Dynamic) -> a {
  do_unsafe_coerce(value)
}

@external(erlang, "gleam_stdlib", "identity")
@external(javascript, "../../../gleam_stdlib/gleam_stdlib.mjs", "identity")
fn do_unsafe_coerce(a: Dynamic) -> a

pub fn from(value: anything) -> Dynamic {
  do_unsafe_from(value)
}

@external(erlang, "gleam_stdlib", "identity")
@external(javascript, "../../../gleam_stdlib/gleam_stdlib.mjs", "identity")
fn do_unsafe_from(a: anything) -> Dynamic
