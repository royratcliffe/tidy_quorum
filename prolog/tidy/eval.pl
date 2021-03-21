:- module(tidy_eval, []).
:- use_module(library(atom)).
:- use_module(library(strings)).
:- use_module(library(readutil)).
:- use_module(library(filesex)).
:- use_module(library(thread_pool)).
:- use_module(library(paxos)).
:- use_module(library(r/r_serve)).
:- use_module(library(r/pax)).
:- use_module(library(tidy/pool)).

:- initialization(up, program).

up :- thread_create(tidy, _, [alias(tidy), detached(true)]).

tidy :-
    repeat,
    forall(r(A), tidy(A)),
    sleep(1),
    fail.

tidy(A) :- restyle_identifier(one_two, A, B), tidy(A, B).

tidy(_, B) :- thread_property(_, alias(B)), !.
tidy(A, B) :- thread_create_in_pool(tidy, eval(A), _,
                                    [ alias(B),
                                      detached(true)
                                    ]).

eval(A) :-
    read_file_to_string(A, B, []),
    split_string(B, "\n", "\r", C),
    string_lines(D, C),
    setup_paxos,
    r_eval_ex($, D, E),
    teardown_paxos,
    (   E \== null
    ->  writeln(E)
    ;   true
    ).

r(A) :- directory_member(., A, [extensions(['R', r]), recursive(true)]).
