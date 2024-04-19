@target(erlang)
@external(erlang, "erlang", "halt")
pub fn exit(code: Int) -> Nil

@target(javascript)
@external(javascript, "../../startest_ffi.mjs", "exit")
pub fn exit(code: Int) -> Nil
