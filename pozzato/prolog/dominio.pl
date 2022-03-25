/*
1   2   3
4   v   5
6   7   8

stato iniziale: [1, 2, 3, 4, v, 5, 6, 7, 8]

1, 3, 4, 6 indici
 

stato finale: [1, 2, 3, 4, 5, 6, 7, 8, v]

*/

membership(_, List) :-
    length(List, 0), fail.
membership(Elem, [Head|_]) :-
    Elem == Head, !.
membership(Elem, [_|Tail]) :-
    membership(Elem, Tail).



iniziale([1, 2, 3, 4, v, 5, 6, 7, 8]).
finale([1, 2, 3, 4, 5, 6, 7, 8, v]).

% applicabile(indice_posizione_vuota, numero_da_scambiare, StatoAttuale)
applicabile(0, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [1, 3]).     % se l'indice è uno di quelli scambiabili con la cella vuota 0 allora possiamo spostare.

applicabile(1, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [0, 2, 4]).     % se l'indice è uno di quelli scambiabili con la cella vuota 1 allora possiamo spostare.

applicabile(2, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [1, 5]).     % se l'indice è uno di quelli scambiabili con la cella vuota 2 allora possiamo spostare.

applicabile(3, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [0, 4, 6]).     % se l'indice è uno di quelli scambiabili con la cella vuota 3 allora possiamo spostare.

% applicabile(indice_posizione_vuota, numero_da_scambiare, StatoAttuale)
applicabile(4, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [1, 3, 4, 6]).     % se l'indice è uno di quelli scambiabili con la cella vuota 4 allora possiamo spostare.

applicabile(5, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [2, 4, 8]).     % se l'indice è uno di quelli scambiabili con la cella vuota 5 allora possiamo spostare.
    
applicabile(6, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [3, 7]).     % se l'indice è uno di quelli scambiabili con la cella vuota 6 allora possiamo spostare.
        
applicabile(7, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [4, 6, 8]).     % se l'indice è uno di quelli scambiabili con la cella vuota 7 allora possiamo spostare.
        
applicabile(8, A, StatoAttuale) :-
    get_index_wrapper(A, StatoAttuale, IndexOfElement),    % troviamo l'indice dell'elemento da spostare
    membership(IndexOfElement, [5, 7]).     % se l'indice è uno di quelli scambiabili con la cella vuota 8 allora possiamo spostare.
        

% data un elemento di una lista e la lista, restituisce l'indice -> -1 
% get_index_wrapper(elemento_da_cercare, lista_in_cui_cercare, indice_risultato)
get_index_wrapper(A, Lista, Index) :- get_index(A, Lista, 0, Index).

get_index(_, [], _, Res) :-
    Res is -1, !.
get_index(A, [Head|_], CurrentIndex, CurrentIndex) :-
    A == Head, !.
get_index(A, [_|Tail], CurrentIndex, IndexResult) :-
    NewCurrent is CurrentIndex + 1,
    get_index(A, Tail, NewCurrent, IndexResult).

% questa implementazione assume come ipotesi iniziale il fatto che il numero possa comparire una volta sola nella lista!
% nel gioco dell'8 o del 15 ogni numero ovviamente compare una volta sola.

%swap(elem1, elem2, list, list_result)
