:- module(tidy_pool, []).
:- autoload(library(thread_pool), [thread_pool_create/3]).

:- multifile thread_pool:create_pool/1.

thread_pool:create_pool(tidy) :-
    current_prolog_flag(cpu_count, A),
    thread_pool_create(tidy, A, []).
