-module(funbox_tests).
-include_lib("eunit/include/eunit.hrl").

prime_test_() ->
    [
    ?_assert(funbox_number:is_prime(5)),
    ?_assertNot(funbox_number:is_prime(6)),
    ?_assertException(error, function_clause, funbox_number:is_prime(-1)),
    ?_assertException(error, function_clause, funbox_number:is_prime(0)),
    ?_assertException(error, function_clause, funbox_number:is_prime(1))
    ].

random_test_() -> 
    [
    ?_assert(is_number(funbox_number:random(2, 10))),
    ?_assert(is_integer(funbox_number:random(2, 10))),
    ?_assert(lists:member(funbox_number:random(2, 10), lists:seq(2, 10)))
    ].