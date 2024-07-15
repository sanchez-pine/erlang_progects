-module(funbox_filter).
-compile(export_all).
-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

-record(state, {client_pid, r_list, r_set}).

init(Args) ->
    {ok, Redis} = eredis:start_link(maps:get(address, Args), maps:get(port, Args)),
    eredis:q_async(Redis, ["BRPOP", maps:get(key_list, Args), 0]),
    {ok, #state{
                client_pid = Redis,
                r_list = maps:get(key_list, Args),
                r_set = maps:get(key_set, Args)
    }}.

handle_info(Info, #state{client_pid = Redis, r_list = List, r_set = Set} = State) ->
    ?LOG_INFO("Info = ~p", [Info]),
    BinaryList = list_to_binary(List),
    {response,{ok,[BinaryList, Value]}} = Info,

    case funbox_number:from_binary(Value) of
        {ok, Number}  ->
            case funbox_number:is_prime(Number) of
                true  ->
                    eredis:q(Redis, ["SADD", Set, Number]);
                false ->
                    ?LOG_INFO("Error: Number = ~p. Not is prime.", [Number])
            end;
        error ->
            ?LOG_INFO("Error: Value = ~p. Not is integer.", [Value])
    end,

    eredis:q_async(Redis, ["BRPOP", List, 0]),
    {noreply, State}.


