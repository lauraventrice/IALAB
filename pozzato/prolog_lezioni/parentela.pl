% fatti
genitore(paolo, mario). % paolo è genitore di mario
genitore(anna, mario). % anna è genitore di luisa
genitore(paolo, luisa). % paolo è genitore di mario
genitore(anna, luisa). % anna è genitore di luisa
genitore(paolo, marco). % paolo è genitore di marco
genitore(mario, chiara). % mario è genitore di chiara
genitore(antonella, chiara). % antonella è genitore di chiara
genitore(mario, alberto). % mario è genitore di alberto
genitore(francesca, alberto). % francesca è genitore di alberto
genitore(marco, serena). % marco è genitore di serena
genitore(serena, fabrizio). % serena è genitore di fabrizio
genitore(fabrizio, lorenzo). % fabrizio è genitore di lorenzo

% regole
nonno(X, Y) :- genitore(X, Z), genitore(Z, Y). % se X è genitore di Z AND Z è genitore di Y allora X è nonno di Y

antenato(X, Y) :- genitore(X, Y). % è il caso base: va definito per primo!
antenato(X, Y) :- nonno(X, Y). % questa è ridondante
antenato(X, Y) :- genitore(X, Z), antenato(Z, Y). % se X è genitore di Z e Z è antenato di di  allora X è antenato di Y

% A è fratello germano di B se hanno tutti e due i genitori in comune
fratelloGermanoOld(A, B) :-
    genitore(PrimoGenitore, A),
    genitore(SecondoGenitore, A),
    genitore(PrimoGenitore, B),
    genitore(SecondoGenitore, B).

% se chiedo fratelloGermano(mario, mario). ottengo true -> dovrei specificare che A e B devono essere diversi

% A è fratello germano di B se hanno tutti e due i genitori in comune e A e B sono diversi
fratelloGermano(A, B) :-
    A \== B,    % A deve essere diverso da B
    genitore(PrimoGenitore, A),
    genitore(SecondoGenitore, A),
    genitore(PrimoGenitore, B),
    genitore(SecondoGenitore, B).

%A \== B è un predicato, un goal da dimostrare e NON un vincolo
%se cerco tutti i fratelli germani di mario con fratelloGermano(mario, X). ottengo X = mario

/*
Call: (10) fratelloGermano(mario, _15858) ? creep
Call: (11) mario\==_15858 ? creep   --> NB!! mario è diverso da _15858!!!!
Exit: (11) mario\==_15858 ? creep
Call: (11) genitore(_18556, mario) ? creep
Exit: (11) genitore(paolo, mario) ? creep
Call: (11) genitore(_20066, mario) ? creep
Exit: (11) genitore(paolo, mario) ? creep
Call: (11) genitore(paolo, _15858) ? creep
Exit: (11) genitore(paolo, mario) ? creep
Call: (11) genitore(paolo, mario) ? creep
Exit: (11) genitore(paolo, mario) ? creep
Exit: (10) fratelloGermano(mario, mario) ? creep
*/

%correggiamo questo problema!

% A è fratello germano di B se hanno tutti e due i genitori in comune e A e B sono diversi
fratelloGermanoFix(A, B) :-
    genitore(PrimoGenitore, A),
    genitore(SecondoGenitore, A),
    genitore(PrimoGenitore, B),
    A \== B,    % A deve essere diverso da B
    genitore(SecondoGenitore, B).

%in tutto ciò le due varibili genitore potrebbero essere istanziate nello stesso modo!

%fratelloGermano(chiara,alberto). mi restituisce true, ma non sono fratelli!!
%hanno mario come genitore in comune

fratelloGermanoCorretto(A, B) :-
    genitore(PrimoGenitore, A),
    genitore(SecondoGenitore, A),
    PrimoGenitore \== SecondoGenitore,
    genitore(PrimoGenitore, B),
    A \== B,    % A deve essere diverso da B
    genitore(SecondoGenitore, B).

fratelliUnilaterali(A, B) :-    %c'è un genitore in comune, gli altri due genitori devono essere diversi e non in comune
    genitore(GenitoreComune, A),
    genitore(GenitoreComune, B),
    A \== B,
    genitore(GenitoreA, A),
    genitore(GenitoreB, B),
    GenitoreA \== GenitoreB,
    GenitoreA \== GenitoreComune,
    GenitoreB \== GenitoreComune.