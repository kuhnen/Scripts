#!/usr/bin/escript
%%! -smp enable -sname test -mnesia debug verbose

main(_) ->
    {ok, Root} = file:get_cwd(),
    io:format("Root -> ~p~n", [Root]),
    Dirs = ["ebin", "priv", "src", "test"],
    create_dirs(Root++"/", Dirs).


create_dirs(_, []) ->
    io:format("dirs created~n");
    
create_dirs(Root, [H|T])->
    NewDir = Root ++ H,
    ok = file:make_dir(NewDir),
    io:format("create -> ~p~n", [NewDir]),
    create_dirs(Root, T).


