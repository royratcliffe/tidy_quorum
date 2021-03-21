:- module(http_r, []).
:- autoload(library(http/http_dispatch), [http_handler/3]).
:- autoload(library(http/http_json), [reply_json/1]).
:- use_module(r/ver).

:- http_handler(root(r/version), ver, []).

ver(_Request) :- r_version(Pairs), reply_json(json(Pairs)).
