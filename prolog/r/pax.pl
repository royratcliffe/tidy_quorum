:- module(r_pax,
          [ setup_paxos/0,
            teardown_paxos/0
          ]).
:- use_module(library(r/r_call)).
:- use_module(library(paxos)).
:- use_module(library(paxos/ledger)).

setup_paxos :-
    findall(A=B, pax(A, B), C),
    compound_name_arguments(D, env, C),
    <- library(rlang),
    paxos <- D.

pax(ledger, E) :-
    findall(B=C, ledger(B, C), D),
    compound_name_arguments(E, env, D).
pax(node, A) :- paxos_property(node(A)).

ledger(A, B) :- current_ledger(A, B), atomic(B).

teardown_paxos :-
    ignore(teardown_paxos(set)),
    ignore(teardown_paxos(get)).

teardown_paxos(Et) :-
    Ls <- ls(),
    memberchk("paxos", Ls),
    LsPaxos <- ls(paxos),
    atom_string(Et, Et1),
    memberchk(Et1, LsPaxos),
    Pairs0 <- ls(paxos$Et),
    maplist({Et}/[Key0, Key0-Value0]>>(Value0 <- paxos$Et$Key0), Pairs0, Pairs),
    atom_concat(paxos_, Et, Goal),
    forall(member(Key-[Value], Pairs), call(Goal, Key, Value)).
