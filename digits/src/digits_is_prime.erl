-module(digits_is_prime).
-export([is_prime/1]).

is_prime(N) ->
    is_prime(N, 2, erlang:trunc(math:sqrt(N)+1)).

is_prime(_, Max, Max) ->
    true;
is_prime(N, I, Max) ->
    if
	N rem I =:= 0, is_integer(N) ->
	    false;
	true ->
	    is_prime(N, I+1, Max)
    end.