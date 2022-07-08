% implementazione euristica 2 che conta il numero di inversioni della lista
% quanti numeri sono più grandi a partire da un numero

heuristic_2_wrapper(CurrentState, Result) :-
    remover(v, CurrentState, ListOfNumbers),    % rimuoviamo la v dalla lista
    inversions(ListOfNumbers, Result).   % contiamo il numero di inversioni nella lista risultante senza la tessera vuota

inversions([], 0).

inversions([_], 0).

inversions([Head | Tail], InvCount) :-
    inv(Head, Tail, Count),
    inversions(Tail, InvTail),
    InvCount is InvTail + Count.

inv(_, [], 0) :- !.

inv(A, [Head | Tail], NewCount) :-
    A >= Head,
    inv(A, Tail, CountTail),
    NewCount is CountTail + 1, !.

inv(A, [_ | Tail], Count) :-
    inv(A, Tail, Count), !.

% predicato che rimuove il primo parametro dalla lista (secondo parametro), formendo la lista risultante in output nel terzo parametro.
% questo predicato viene usato in quanto per contare il numero di inversioni non abbiamo bisogno della v (tessera vuota) all'interno della lista.
remover(_, [], []).
remover(R, [R|T], T).
remover(R, [H|T], [H|T2]) :- H \= R, remover( R, T, T2).