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
%iniziale([1, 2, 3, 4, 5, 6, 7, v, 8]).
finale([1, 2, 3, 4, 5, 6, 7, 8, v]).

/*
applicabile(NumberToMove, CurrentState) :-
    get_index_wrapper(v, CurrentState, IndexV),
    get_index_wrapper(Numero, CurrentState, IndexNum),
    number_that_can_be_moved(IndexV, S),
    membership(IndexNum, S). 
*/

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

% index_move(FreePosition, IndexList). indici che possono essere spostati in base alla FreePosition
index_move(0, [1, 3]).
index_move(1, [0, 2, 4]).
index_move(2, [1, 5]). 
index_move(3, [0, 4, 6]).
index_move(4, [1, 3, 5, 7]).
index_move(5, [2, 4, 8]).
index_move(6, [3, 7]).
index_move(7, [4, 6, 8]).
index_move(8, [5, 7]).


        
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


/*
Stati visitati -> lista di liste!
*/

% cerca_soluzione(-ActionList)
cerca_soluzione(ActionList) :-
    iniziale(InitialS),
    profondita(InitialS, ActionList, []).

% profondita(CurrentState, ActionList, VisitatedStates)
profondita(CurrentS, [], _):-
    finale(CurrentS), !.
profondita(CurrentS,[Az|ActionList],Visited):-
    write(CurrentS),
    applicabile(Az, CurrentS),
    trasforma(Az,CurrentS,NewS),
    \+member(NewS,Visited),
    profondita(NewS,ActionList,[CurrentS|Visited]).


iterative_deepening_wrapper(ActionList, StartIndex, Limit) :-
    iterative_deepening(ActionList, StartIndex, Limit).

iterative_deepening(_, Bound, Limit) :-
    Bound == Limit, !.
iterative_deepening(ActionList, Bound, Limit) :-
    %write(Bound),
    %write("\n"),
    Bound < Limit,
    NewBound is Bound + 1,
    \+cerca_soluzione_soglia(ActionList, Bound), 
    iterative_deepening(ActionList, NewBound, Limit).


% cerca_soluzione_soglia(-ActionList,+Limit)
cerca_soluzione_soglia(ActionList, Bound):-
    iniziale(InitialS),
    prof_limitata(InitialS,ActionList,[],Bound).

% prof_limitata(S,ListaAzioni,Visitati,Soglia)
prof_limitata(CurrentS,[],_,_):-finale(CurrentS),!.

prof_limitata(CurrentS, [Az|ActionList], Visited, Bound):-
    applicabile(Az, CurrentS),
    trasforma(Az, CurrentS, NewS),
    \+member(NewS, Visited),
    Bound>0,
    NewBound is Bound-1,
    prof_limitata(NewS, ActionList, [CurrentS|Visited], NewBound).


/*
findall è un predicato con 3 argomenti,

trovami tutti i valori di X per cui il secondo parametro è vero e mettimi il risultato in una lista (terzo paramertro)

?- findall(X, member(X, [1,2,ciccio]), Risultato).
Risultato = [1, 2, ciccio].


?- iniziale(S), findall(Azione, applicabile(Azione, S), AzioniApplicabili).
S = pos(4, 2),
AzioniApplicabili = [nord, sud, ovest, est].

mi trova tutte le azioni applicabili in S

?- findall(Azione, applicabile(Azione, pos(1,1)), AzioniApplicabili).
AzioniApplicabili = [sud, est].

mi trova tutte le azioni applicabili in pos(1,1)
*/

/*
6 4 2
3 5 1
v 8 7

[4,2,v,6,5,1,3,8,7][4,2,v,6,5,1,3,8,7][4,v,2,6,5,1,3,8,7][4,v,2,6,5,1,3,8,7]
[v,4,2,6,5,1,3,8,7][v,4,2,6,5,1,3,8,7][6,4,2,v,5,1,3,8,7][6,4,2,v,5,1,3,8,7]
[6,4,2,3,5,1,v,8,7][6,4,2,3,5,1,v,8,7][6,4,2,3,5,1,8,v,7][6,4,2,3,5,1,8,v,7][6,4,2,3,5,1,8,7,v]
*/