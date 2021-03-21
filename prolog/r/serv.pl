:- module(r_serv,
          [ rserve_process/1
          ]).
:- autoload(library(process), [process_create/3]).

:- dynamic process/1.

:- initialization(up, program).

up :-
    process_create(path('R'),
                   ['CMD', 'Rserve', '--no-save'],
                   [detached(true), process(Process)]),
    assertz(process(Process)).

rserve_process(Process) :- process(Process).
