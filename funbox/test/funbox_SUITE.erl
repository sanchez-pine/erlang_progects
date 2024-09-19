-module(funbox_SUITE).
-include_lib("common_test/include/ct.hrl").
%-export([init_per_testcase/2, end_per_testcase/2, check_is_prime_number_tests/1]).
-compile([export_all, nowarn_export_all]).
%-compile(export_all).

all() -> [check_is_prime_number_tests, check_count_values_in_redis_set, eredis_tests, check_clear_redis_list_tests].

init_per_testcase(_Testcase, Config) ->
    {ok, Redis} = eredis:start_link(),
    {ok, _Gen} = funbox_filter:start_link(#{address => "127.0.0.1", port => 6379, key_list => "key", key_set => "superkey"}),
    [{redis, Redis} | Config].

end_per_testcase(_Testcase, Config) ->
    Redis = ?config(redis, Config),
    {ok, _} = eredis:q(Redis, ["FLUSHDB"]),
    ok.

check_is_prime_number_tests(Config) ->
    Redis = ?config(redis, Config),
    {ok, _} = eredis:q(Redis, ["LPUSH", "key", -1, 0, 1, 2, 3, 4, 5, 7, 10, 2, 1, 15, 17, a, zb]),
    timer:sleep(1000),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", -1]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 0]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 1]),
    {ok,<<"1">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 2]),
    {ok,<<"1">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 3]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 4]),
    {ok,<<"1">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 5]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 15]),
    {ok,<<"1">>} = eredis:q(Redis, ["SISMEMBER", "superkey", 17]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", a]),
    {ok,<<"0">>} = eredis:q(Redis, ["SISMEMBER", "superkey", zb]).

check_count_values_in_redis_set(Config) ->
    Redis = ?config(redis, Config),
    {ok, _} = eredis:q(Redis, ["LPUSH", "key", 1, 2, 3, 4, 5, 7, 10, 2, 1, 15, 17, a, zb]),
    timer:sleep(1000),
    {ok, Bincount} = eredis:q(Redis, ["SCARD", "superkey"]),
    5 = binary_to_integer(Bincount).

eredis_tests(Config) ->
    C = ?config(redis, Config),
    {ok, <<"OK">>} = eredis:q(C, ["SET", "foo", "bar"]),
    {ok, <<"bar">>} = eredis:q(C, ["GET", "foo"]),
    %%LISTS
    eredis:q(C, ["LPUSH", "keylist", "value"]),
    eredis:q(C, ["RPUSH", "keylist", "value"]),
    eredis:q(C, ["LRANGE", "keylist",0,-1]),
    %%MSET, MGET
    KeyValuePairs = ["key1", "value1", "key2", "value2", "key3", "value3"],
    {ok, <<"OK">>} = eredis:q(C, ["MSET" | KeyValuePairs]),
    {ok, _Values} = eredis:q(C, ["MGET" | ["key1", "key2", "key3"]]).

check_clear_redis_list_tests(Config) ->
    Redis = ?config(redis, Config),
    {ok, _} = eredis:q(Redis, ["LPUSH", "key", 15]),
    {ok, _} = eredis:q(Redis, ["LPUSH", "key", 1, 2, 3, 4, 5, a, z, -1]),
    timer:sleep(1000),
    {ok, []} = eredis:q(Redis, ["LRANGE", "key", 0, -1]).