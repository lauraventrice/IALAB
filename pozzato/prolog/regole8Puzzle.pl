/*
applicabile(NumberToMove, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(Numero, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S). 
*/

:- ['dominio.pl'].

applicabile(1, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(1, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).
    
applicabile(2, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(2, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).    

applicabile(3, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(3, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).

applicabile(4, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(4, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).

applicabile(5, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(5, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).

applicabile(6, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(6, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).

applicabile(7, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(7, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).

applicabile(8, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(8, CurrentState, IndexNum),
    index_move(IndexV, S),
    membership(IndexNum, S).


/*
Change current state with swap between Num and v, which is the empty position. 
trasforma(Num, CurrentState, ResultState)
*/
trasforma(Num, CurrentState, ResultState) :-
    swap(Num, v, CurrentState, ResultState).



%Funzioni di supporto

/*
Return the index of the occurence of the specified element (ElemToFind) in
ListWhereToFind, or -1if the list does not contain the element. 
    get_index_wrapper(ElemToFind, ListWhereToFind, ResultIndex)
*/

get_index_wrapper(Elem, List, ResultIndex) :- get_index(Elem, List, 0, ResultIndex).

get_index(_, [], _, ResultIndex) :-
    ResultIndex is -1, !.
get_index(Elem, [Head|_], CurrentIndex, CurrentIndex) :-
    Elem == Head, !.
get_index(Elem, [_|Tail], CurrentIndex, ResultIndex) :-
    NewCurrent is CurrentIndex + 1,
    get_index(Elem, Tail, NewCurrent, ResultIndex).

/*
Return a new list which has Elem1 and Elem2 swapped. 
PRECOND: List contains both Elem1 and Elem2. 
swap(Elem1, Elem2, List, ListResult)
*/

swap(_, _, [], []) :- !.
swap(Elem1, Elem2, [Head|Tail], [Elem2|ListResult]) :-
    Elem1 == Head, !, swap(Elem1, Elem2, Tail, ListResult). 
swap(Elem1, Elem2, [Head|Tail], [Elem1|ListResult]) :-
    Elem2 == Head, !, swap(Elem1, Elem2, Tail, ListResult). 
swap(Elem1, Elem2, [Head|Tail], [Head|ListResult]) :-
    Elem1 \== Head, Elem2 \== Head, swap(Elem1, Elem2, Tail, ListResult). 
