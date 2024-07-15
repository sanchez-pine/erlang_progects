-module(funbox_number).
-export([is_prime/1, random/2]).
-compile(export_all).

-spec from_binary(Binary :: binary()) -> {ok, integer()}.

from_binary(Binary) ->
    try
        {ok, binary_to_integer(Binary)}
    catch
        error:badarg -> error
    end.

is_prime(N) when N > 1 ->
    is_prime(N, 2, erlang:trunc(math:sqrt(N)+1));
is_prime(N) when N =< 1 ->
    false.

is_prime(_, Max, Max)  ->
    true;
is_prime(N, I, Max) when N rem I =:= 0 ->
    false;
is_prime(N, I, Max)    ->
    is_prime(N, I+1, Max).

random(2, N)           ->
    rand:uniform(N - 1)+1.

