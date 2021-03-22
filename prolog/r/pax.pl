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
    A <- ls(paxos),
    memberchk("set", A),
    B <- ls(paxos$set),
    maplist([X, X-Y]>>(Y <- paxos$set$X), B, C),
    forall(member(D-[E], C), paxos_set(D, E)).
