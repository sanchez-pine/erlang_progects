-module(funbox_number_tests).
-include_lib("eunit/include/eunit.hrl").

is_prime_test_() ->
    [
    ?_assert(funbox_number:is_prime(5)),
    ?_assertNot(funbox_number:is_prime(6))
    ].

random_test_() -> 
    [
    ?_assert(is_integer(funbox_number:random(2, 10))),
    ?_assert(lists:member(funbox_number:random(2, 10), lists:seq(2, 10)))
    ].