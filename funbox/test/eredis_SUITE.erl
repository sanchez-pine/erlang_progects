-module(eredis_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0, init_per_testcase/2, end_per_testcase/2]).
-export([eredis_tests/1]).

all() -> [eredis_tests].

init_per_testcase(eredis_tests, Config) ->
    {ok, C} = eredis:start_link(),
    [{pid, C} | Config].

end_per_testcase(eredis_tests, Config) ->
    _C = ?config(pid, Config).

eredis_tests(Config) ->
    C = ?config(pid, Config),
    {ok, <<"OK">>} = eredis:q(C, ["SET", "foo", "bar"]),
    {ok, <<"bar">>} = eredis:q(C, ["GET", "foo"]),
    %%LISTS
    eredis:q(C, ["LPUSH", "keylist", "value"]),
    eredis:q(C, ["RPUSH", "keylist", "value"]),
    eredis:q(C, ["LRANGE", "keylist",0,-1]),
    %%MSET, MGET
    KeyValuePairs = ["key1", "value1", "key2", "value2", "key3", "value3"],
    {ok, <<"OK">>} = eredis:q(C, ["MSET" | KeyValuePairs]),
    {ok, Values} = eredis:q(C, ["MGET" | ["key1", "key2", "key3"]]).