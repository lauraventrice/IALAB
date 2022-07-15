/* Considerazioni iniziali: 

1   2   3
4   v   5
6   7   8

stato iniziale: [1, 2, 3, 4, v, 5, 6, 7, 8]

1, 3, 4, 6 indici
 

stato finale: [1, 2, 3, 4, 5, 6, 7, 8, v]

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



iniziale([1, 3, v, 7, 2, 4, 8, 6, 5]). 
finale([1, 2, 3, 4, 5, 6, 7, 8, v]).

% index_move(EmptyPosition, ListIndexes): list of indexes, that are position that can be moved, linked with the empty position
index_move(0, [1, 3]).
index_move(1, [0, 2, 4]).
index_move(2, [1, 5]). 
index_move(3, [0, 4, 6]).
index_move(4, [1, 3, 5, 7]).
index_move(5, [2, 4, 8]).
index_move(6, [3, 7]).
index_move(7, [4, 6, 8]).
index_move(8, [5, 7]).