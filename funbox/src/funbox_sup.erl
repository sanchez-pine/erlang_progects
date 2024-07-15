-module(funbox_sup).
-compile(export_all).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    AllArgs = #{
        address      => get_value(address),
        count        => get_value(count),
        key_list     => get_value(key_list),
        key_set      => get_value(key_set),
        port         => get_value(port),
        range_number => get_value(range_number)},

    SupSpec = #{
        strategy     => one_for_one,
        intensity    => 10,
        period       => 60},

    ChildSpec =
        [#{id       => funbox_filter1,
           start    => {funbox_filter, start_link, [AllArgs]},
           restart  => permanent,
           shutdown => 2000,
           type     => worker,
           modules  => [funbox_filter]},

         #{id       => funbox_filter2,
           start    => {funbox_filter, start_link, [AllArgs]},
           restart  => permanent,
           shutdown => 2000,
           type     => worker,
           modules  => [funbox_filter]},

         #{id       => funbox_filter3,
           start    => {funbox_filter, start_link, [AllArgs]},
           restart  => permanent,
           shutdown => 2000,
           type     => worker,
           modules  => [funbox_filter]},

         #{id       => funbox_writer,
           start    => {funbox_writer, start_link, [AllArgs]},
           restart  => permanent,
           shutdown => 2000,
           type     => worker,
           modules  => [finbox_writer]}
        ],
    {ok, {SupSpec, ChildSpec}}.

get_value(Key) ->
    {ok, Value} = application:get_env(funbox, Key),
    Value.