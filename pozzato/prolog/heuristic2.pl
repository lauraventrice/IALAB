inversions([], 0).

inversions([_], 0).

inversions([Head | Tail], InvCount) :-
    inv(Head, Tail, Count),
    inversions(Tail, InvTail),
    InvCount is InvTail + Count.

%TODO: rivedere l'implementazione di questa euristica!!!!!!!

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

heuristic_2_wrapper(CurrentState, Result) :-
    remover(v, CurrentState, ListOfNumbers),    % rimuoviamo la v dalla lista
    inversions(ListOfNumbers, Result).   % contiamo il numero di inversioni nella lista risultante senza la tessera vuota



% :- use_module(library(clpfd)).

% inversions(L, C) :-
%     L ins 0..9,
%     all_distinct(L),
%     count_inv(L, C).

% % Count inversions    
% count_inv([], 0).
% count_inv([X|T], C) :-
%     count_inv(X, T, C1),     % Count inversions for current element
%     C #= C1 + C2,            % Add inversion count for the rest of the list
%     count_inv(T, C2).        % Count inversions for the rest of the list

% count_inv(_, [], 0).
% count_inv(X, [Y|T], C) :-
%     (   X #> Y, X #> 0, Y #> 0
%     ->  C #= C1 + 1,         % Valid inversion, count it
%         count_inv(X, T, C1)
%     ;   count_inv(X, T, C)
%     ).

