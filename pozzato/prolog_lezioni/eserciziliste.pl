%somma degli elementi di una lista

somma([], 0).
somma([Head|Tail], FirstRes) :-
    somma(Tail, Res), FirstRes is Res + Head.

%moltiplicazione degli elementi di una lista
moltiplicazione([], 0).
moltiplicazione([Head|[]], FirstRes) :-
    !, FirstRes is Head.
moltiplicazione([Head|Tail], FirstRes) :-
    moltiplicazione(Tail, Res), !, FirstRes is Res * Head.     %grazie al cut (!) poto dei rami di backtracking e se intraprendo questa strada ottengo solo il risultato corretto e non anche 0.

% trovare il massimo in una lista
trovamassimo([], 0).
trovamassimo([Head|Tail], Max) :-
    trovamassimoaux([Head|Tail], Max).

trovamassimoaux([], 0).
trovamassimoaux([Head|Tail], Head) :-
    trovamassimoaux(Tail, NextMax),
    Head > NextMax.

trovamassimoaux([Head|Tail], NextMax) :-
    trovamassimoaux(Tail, NextMax),
    Head < NextMax.

%funziona, ma ci mette davvero tanto (basta guardare il trace).

/*
Exercise 2.2. Write a Prolog predicate membership/2 that works like the built-in predicate member/2 (without using member/2).
*/
membership(_, []) :- false.
membership(A, [Head|_]) :-
    A == Head, !.
membership(A, [_|Tail]) :-
    membership(A, Tail).

/*
Exercise 2.3. Implement a Prolog predicate remove_duplicates/2 that removes all duplicate elements from a list given in the first argument and returns the result in the second argument position. Example:
     ?- remove_duplicates([a, b, a, c, d, d], List).
     List = [b, a, c, d]
     Yes
*/

remove_duplicates([], []).
remove_duplicates([Head|Tail], [Head|ListTail]) :-
    \+member(Head, Tail),
    remove_duplicates(Tail, ListTail).
remove_duplicates([Head|Tail], ListTail) :-
    member(Head, Tail),
    remove_duplicates(Tail, ListTail).

remove_duplicatesV2([], []).
remove_duplicatesV2([Head|Tail], [Head|ListTail]) :-
    \+member(Head, Tail), !,
    remove_duplicatesV2(Tail, ListTail).
remove_duplicatesV2([_|Tail], ListTail) :-
    remove_duplicatesV2(Tail, ListTail).

/*
Exercise 2.4. Write a Prolog predicate reverse_list/2 that works like the built-in predicate reverse/2 (without using reverse/2). Example:
     ?- reverse_list([tiger, lion, elephant, monkey], List).
     List = [monkey, elephant, lion, tiger]
     Yes

*/

reverse_list([], []).
reverse_list([A], [A|[]]).
reverse_list([Head|Tail], Res) :-
    reverse_list(Tail, ReversedTail),
    append(ReversedTail, [Head], Res).

/*
Exercise 2.5. Consider the following Prolog program:

whoami([]).
whoami([_, _ | Rest]) :-
  whoami(Rest).

Under what circumstances will a goal of the form whoami(X) succeed?

Ritorna true se la lista ha un numero pari di elementi!
*/

whoami([]).
whoami([_, _ | Rest]) :-
  whoami(Rest).

/*
Exercise 2.6. The objective of this exercise is to implement a predicate for returning
the last element of a list in two different ways.
(a) Write a predicate last1/2 that works like the built-in predicate last/2 using a recursion and the head/tail-pattern of lists.
(b) Define a similar predicate last2/2 solely in terms of append/3, without using a recursion.
*/

% VERSIONE A
last1([], _) :- false.
last1([A], Last) :- 
    !, Last is A.
last1([_|Tail], Elem) :-
    last1(Tail, Elem), !.

% VERSIONE B
%DA FARE

/*
Exercise 2.7. Write a predicate replace/4 to replace all occurrences of a given element (second argument) by another given element (third argument) in a given list (first argument). Example:
     ?- replace([1, 2, 3, 4, 3, 5, 6, 3], 3, x, List).
     List = [1, 2, x, 4, x, 5, 6, x]
     Yes
*/

replace([], _, _, []).
replace([A], DaSostituire, Sostituto, [Sostituto]) :-
    A == DaSostituire.
replace([Head|Tail], DaSostituire, Sostituto, [Sostituto|Res]) :-
    Head == DaSostituire, !,
    replace(Tail, DaSostituire, Sostituto, Res).
replace([Head|Tail], DaSostituire, Sostituto, [Head|Res]) :-
    replace(Tail, DaSostituire, Sostituto, Res).


/*
Exercise 2.8. Prolog lists without duplicates can be interpreted as sets. Write a program that given such a list computes the corresponding power set. Recall that the power set of a set S is the set of all subsets of S. This includes the empty set as well as the set S itself.
Define a predicate power/2 such that, if the first argument is instantiated with a list, the corresponding power set (i.e. a list of lists) is returned in the second position. Example:
     ?-  power([a, b, c], P).
     P = [[a, b, c], [a, b], [a, c], [a], [b, c], [b], [c], []]
     Yes
Note: The order of the sub-lists in your result doesn’t matter.
*/

power([], [[]]).
power([A], [[A]]).
power([A, B | Rest], Result) :-
    power([B | Rest], NextRes),
    append([[A, B | Rest], [A], [B], [A, B]], NextRes, Result).

%NON FUNZIONA CORRETTAMENTE