-module(funbox_number).
-export([is_prime/1, random/2]).

is_prime(N) ->
    is_prime(N, 2, erlang:trunc(math:sqrt(N)+1)).

is_prime(_, Max, Max) ->
    true;
is_prime(N, I, Max)   ->
    if
	N rem I =:= 0, is_integer(N) ->
	    false;
	true ->
	    is_prime(N, I+1, Max)
    end.

random(N, Count)         ->
    random(N, Count, 0, []).

random(_, Max, Max, Acc) ->
    Acc;
random(N, Count, I, Acc) ->
    H = rand:uniform(N),
    if
        H =:= 1 ->
            random(N, Count, I+1, [H+1|Acc]);
        H > 1   ->
            random(N, Count, I+1, [H|Acc])
    end.
