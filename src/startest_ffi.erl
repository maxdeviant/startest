-module(startest_ffi).

-export([get_exports/1]).

get_exports(Module) ->
    Exports = Module:module_info(exports),
    lists:map(fun({FnName, _Arity}) ->
                  {FnName, fun() -> apply(Module, FnName, []) end}
              end, Exports).
