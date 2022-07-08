% questa euristica implementa il conteggio del numero di tessere fuori posto nel puzzle.

% heuristic_1(CurrentState, FinalState)
% i due stati sono rappresentati da liste di lunghezza uguale
% ATTENZIONE: contiamo anche la tessera vuota -> questo non è affatto un problema

:- ['dominio.pl'].

heuristic_1_wrapper(CurrentState, Result) :-
    finale(FinalState),
    heuristic_1(CurrentState, FinalState, 0, Result).

heuristic_1([], [], Count, Result) :-
    Result is Count.
heuristic_1([HeadCS|TailCS], [HeadFS|TailFS], Count, NewResult) :- 
    HeadCS \== HeadFS, !,
    NewCount is Count + 1,
    heuristic_1(TailCS, TailFS, NewCount, NewResult).
heuristic_1([_|TailCS], [_|TailFS], Count, Result) :-
    heuristic_1(TailCS, TailFS, Count, Result).

