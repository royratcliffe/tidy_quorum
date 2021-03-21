:- module(r_ver,
          [ r_version/1
          ]).
:- use_module(library(r/r_call)).
:- use_module(library(apply)).
:- use_module(library(pairs)).
:- use_module(library(yall)).

r_version(Pairs) :-
    Keys <- names('R'.'Version'()),
    Values <- 'R'.'Version'(),
    pairs_keys_values(Pairs0, Keys, Values),
    maplist([Key-[Value], Key=Value]>>true, Pairs0, Pairs).
