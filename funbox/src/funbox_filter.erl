-module(funbox_filter).
-compile(export_all).
-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

-record(state, {client_pid}).

init([]) ->
    {ok, Redis} = eredis:start_link(),
    eredis:q_async(Redis, ["BRPOP", "key", 0]),
    {ok, #state{client_pid = Redis}}.


handle_info(Info, #state{client_pid = Redis} = State) ->
    ?LOG_INFO("Info = ~p", [Info]),
    {response,{ok,[<<"key">>, Value]}} = Info,

    case funbox_number:from_binary(Value) of
        {ok, Number}  ->
            case funbox_number:is_prime(Number) of
                true  ->
                    eredis:q(Redis, ["SADD", "superkey", Number]);
                false ->
                    ok
            end;
        error ->
            ok
    end,

    eredis:q_async(Redis, ["BRPOP", "key", 0]),
    {noreply, State}.


