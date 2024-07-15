-module(funbox_filter).
-compile(export_all).
-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

%start_link()     ->
%    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_link(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE,
    #{address => "127.0.0.1", port => 6379, key_list => "key", key_set => "superkey"},
    []).

-record(state, {client_pid}).
%-record(state, {
%                client_pid,
%                address = "127.0.0.1",
%                port    = 6379,
%                key_list = "key",
%                key_set = "superkey"
%               }).
%Mapper = #{address => "127.0.0.1", port => 6379, key_list => "key"}.

init(Args) ->
    {ok, Redis} = eredis:start_link(maps:get(address, Args), maps:get(port, Args)),
    eredis:q_async(Redis, ["BRPOP", maps:get(key_list, Args), 0]),
%    {ok, Args#{address => "127.0.0.1", port => 6379, key_list => "key", key_set => "superkey"}}.
    {ok, #state{client_pid = Redis}}.

%init([]) ->
%    {ok, Redis} = eredis:start_link(),
%    eredis:q_async(Redis, ["BRPOP", "key", 0]),
%    {ok, #state{client_pid = Redis}}.

handle_info(Info, #state{client_pid = Redis} = State) ->
%handle_info(Info, State)
    ?LOG_INFO("Info = ~p", [Info]),
    {response,{ok,[<<"key">>, Value]}} = Info,

    case funbox_number:from_binary(Value) of
        {ok, Number}  ->
            case funbox_number:is_prime(Number) of
                true  ->
                    eredis:q(Redis, ["SADD", "superkey", Number]);
                false ->
                    ?LOG_INFO("Error: Number = ~p. Not is prime.", [Number])
            end;
        error ->
            ?LOG_INFO("Error: Value = ~p. Not is integer.", [Value])
    end,

    eredis:q_async(Redis, ["BRPOP", "key", 0]),
    {noreply, State}.


