-module(funbox_utimer).
-export([sleep/1]).

sleep(Count) ->
    timer:sleep(Count/1000).