-module(funbox_utimer).
-export([sleep/1]).
-export([seconds/1]).

-define(NOW(), erlang:monotonic_time(microsecond)).

seconds(Seconds) ->
    1000 * 1000 * Seconds.

sleep(Time) ->
    sleep_until(?NOW() + Time).

sleep_until(Deadline) ->
    case ?NOW() < Deadline of
	true  -> sleep_until(Deadline);
	false -> ok
    end.
