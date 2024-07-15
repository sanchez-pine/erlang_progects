-module(funbox_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    io:format("Приложение ~p запущено.~n", [?MODULE]),
    funbox_sup:start_link().

stop(_State) ->
    io:format("Приложение ~p остановлено.~n", [?MODULE]),
    ok.