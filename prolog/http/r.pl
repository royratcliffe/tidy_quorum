:- module(http_r, []).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_json), [reply_json/1]).
:- autoload(library(http/http_client), [http_read_data/3]).
:- use_module(library(r/ver)).
:- use_module(library(tidy/eval)).

:- http_handler(root(r/version), ver, []).
:- http_handler(root(r/eval), eval, [method(post), spawn]).

ver(_Request) :- r_version(Pairs), reply_json(json(Pairs)).

eval(Request) :-
    http_read_data(Request, Command, [to(string)]),
    eval(Command, Results),
    format('Content-Type: text/plain~n~n~q', [Results]).
