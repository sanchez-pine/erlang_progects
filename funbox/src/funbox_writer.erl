-module(funbox_writer).
-compile(export_all).
-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

start_link(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

-record(state, {client_pid, r_list, range_num, time_delay}).

init(Args) ->
    {ok, Redis} = eredis:start_link(maps:get(address, Args), maps:get(port, Args)),
    TimeDelay = 1_000_000 div maps:get(count, Args),
    {ok, #state{
                client_pid = Redis,
                r_list = maps:get(key_list, Args),
                range_num = maps:get(range_number, Args),
                time_delay = TimeDelay
    }, {continue, loop}}.

handle_continue(loop, #state{client_pid = Redis, r_list = List, range_num = Num, time_delay = Delay} = State) ->
%    {Func1, Result} = timer:tc(funbox_number, random, [2, Num]),
    {Func1, _Res} = timer:tc(fun() ->
        Result = funbox_number:random(2, Num),
        eredis:q(Redis, ["LPUSH", List, Result]) end),
%    eredis:q(Redis, ["LPUSH", List, Result]),
    funbox_utimer:sleep(Delay - Func1),
    {noreply, State, {continue, loop}}.

