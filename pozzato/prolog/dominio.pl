/* Considerazioni iniziali: 

1   2   3   4  
5   6   7   8
15  9   10  11
12  13  v   14

stato iniziale: [1, 2, 3, 4, 5, 6, 7, 8, 15, 9, 10, 11, 12, 13, v, 14]

stato finale: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, v]

Questa implementazione assume come ipotesi iniziale il fatto che il numero possa comparire una volta sola nella lista!
nel gioco dell'8 o del 15 ogni numero ovviamente compare una volta sola.
*/


%membership(Elem, List): is true iff Elem is member of the List.  
membership(_, List) :-
    length(List, 0), fail.
membership(Elem, [Head|_]) :-
    Elem == Head, !.
membership(Elem, [_|Tail]) :-
    membership(Elem, Tail).

iniziale([1, 2, 3, 4, 5, 6, 7, 8, 15, 9, 10, 11, 12, 13, v, 14]).

finale([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, v]).

% index_move(EmptyPosition, ListIndexes): list of indexes, that are position that can be moved, linked with the empty position
index_move(0, [1, 4]).
index_move(1, [0, 2, 5]).
index_move(2, [1, 3, 6]). 
index_move(3, [2, 7]).
index_move(4, [0, 5, 8]).
index_move(5, [1, 4, 6, 9]).
index_move(6, [2, 5, 7, 10]).
index_move(7, [3, 6, 11]).
index_move(8, [4, 9, 12]).
index_move(9, [5, 8, 10, 13]).
index_move(10, [6, 9, 11, 14]).
index_move(11, [7, 10, 15]).
index_move(12, [8, 13]).
index_move(13, [9, 12, 14]).
index_move(14, [10, 13, 15]).
index_move(15, [11, 14]).