-module(funbox_tests).
-include_lib("eunit/include/eunit.hrl").

prime_test() ->
    ?assert(funbox:is_prime(5)),
    ?assertNot(funbox_number:is_prime(6)).


%%recursion_test(N) -> 
%%    recursion_test(N, 2, erlang:trunc(math:sqrt(N)+1)).
%%recursion_test(_, Max, Max) ->
%%    true;
%%recursion_test(N, I, Max) ->
%%    if
%%	N dev I =:= 0 ->
%%	    ?assertNot(digit_is_prime:is_prime(N));
%%	true ->
%%	    ?assert(digit_is_prime:is_prime(N))
%%	    recursion_test(N, I+1, Max)
%%    end.
