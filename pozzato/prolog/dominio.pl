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



iniziale([1, 2, 3, 4, v, 5, 6, 7, 8]).
finale([1, 2, 3, 4, 5, 6, 7, 8, v]).

/*
applicabile(IndexEmptyPosition, NumberToMove, CurrentState) :-
    get_index_wrapper(NumberToMove, CurrentState, IndexOFElement),   --find the index of the element to move
    membership(IndexOfElement, *list of indexes which can move*).    --if the index is in the list we can move the number
*/
applicabile(0, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),   
    membership(IndexOfElement, [1, 3]). 

applicabile(1, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),    
    membership(IndexOfElement, [0, 2, 4]).   

applicabile(2, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),
    membership(IndexOfElement, [1, 5]).     

applicabile(3, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),
    membership(IndexOfElement, [0, 4, 6]).

applicabile(4, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),  
    membership(IndexOfElement, [1, 3, 4, 6]).     

applicabile(5, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),   
    membership(IndexOfElement, [2, 4, 8]).    
    
applicabile(6, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),   
    membership(IndexOfElement, [3, 7]). 
        
applicabile(7, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement),
    membership(IndexOfElement, [4, 6, 8]).     
        
applicabile(8, Num, CurrentState) :-
    get_index_wrapper(Num, CurrentState, IndexOfElement), 
    membership(IndexOfElement, [5, 7]).     
        
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


/*
Change current state with swap between Num and v, which is the empty position. 
trasforma(Num, CurrentState, ResultState)
*/
trasforma(Num, CurrentState, ResultState) :-
    swap(Num, v, CurrentState, ResultState).
