/*

[Head|Tail]=[ciao,ei_tu,amicodi(luca),[1,2,3], 'hello world'].

Head = ciao,
Tail = [ei_tu, amicodi(luca), [1, 2, 3], 'hello world'].


?- [Head|Tail]=[[x, 3, z], ciao,ei_tu,amicodi(luca),[1,2,3], 'hello world'].

Head = [x, 3, z],
Tail = [ciao, ei_tu, amicodi(luca), [1, 2, 3], 'hello world'].

*/

/*
member(elem, lista)

cosa fa member? member restituisce true se elem appartiene alla lista

member(X, [1,3,2,4]).   cerca di dirci per quali valori di X si ottiene true
X = 1 ;
X = 3 ;
X = 2 ;
X = 4.

member(23, [11,5,[45,23],78]).
false.

NB! member non va a fondo!
*/

/*

select(25, [-4,23,11,25,7], ListaRisultato).
ListaRisultato = [-4, 23, 11, 7] ;

la select ha successo se:
    - ha successo la member (25 deve essere presente nella lista)
    - il terzo arogmento coincide con la lista da cui è stato eliminato quell'elemento

select(25, [-4,23,11,25,7], [-4, 23, 11, 7]).
true .

25 appartiene alla lista [-4,23,11,25,7]?
Se si, la lista senza 25 coincide con [-4,23,11,25,7]?

select(25, [-4,23,11,25,7,25, 25,6], ListaRisultato).
ListaRisultato = [-4, 23, 11, 7, 25, 25, 6] .

NB! viene rimosso solo il primo 25, non tutti i 25!!

NB! anche il select non va a fondo, appena trova il primo elento che soddisfa la member si ferma!

*/

/*

append([1,ciao],[23,45,[],11], Res).
Res = [1, ciao, 23, 45, [], 11].

append([1,2],[3,4], [1,2,3,4]).
true.

Se unisco le liste [1,2] e [3,4] ottengo la lista [1,2,3,4]? Si!

*/

/*
is_list([23]).
true.

is_list(23).
false.

is_list restituisce true se l'argomento è una lista.

*/

/*

var(13).
false.

var(Res).
true.

var restituisce true se l'argomento è una variabile

*/


%predicato(+arg1, -arg2, ?arg3)
% +: deve essere per forza presente - parametro di input
% -: non deve essere istanziato - parametro di aoutput
% ?: può essere sia di input che di output
% noi potremmo avere solo parametri con +, nessuno lo vieta

%esercizio: somma
%somma(+Lista, -Somma)
%lo definiamo induttivamente!

somma([], 0).
somma([Head|Tail], Res) :-
    somma(Tail, SommaTail),  % SommaTail viene istanziata con la somma dei valori di Tail
    Res is Head + SommaTail.   % A SommaTail aggiungo Head e assegno il risultato con "is" nella variabile Res
    % NB!! in prolog il "più" (+) ha senso se messo nell'"is"!
    % esistono anche gli altri operatori
/*

somma([1,2,3], Tot).
Tot = 6 .

somma([1,2,3,10], Res).
Res = 16 .


[trace]  ?- somma([1,2,3], Res).                                                                                                
   Call: (10) somma([1, 2, 3], _9998) ? creep
   Call: (11) somma([2, 3], _11244) ? creep
   Call: (12) somma([3], _12000) ? creep
   Call: (13) somma([], _12756) ? creep
   Exit: (13) somma([], 0) ? creep
   Call: (13) _12000 is 3+0 ? creep
   Exit: (13) 3 is 3+0 ? creep
   Exit: (12) somma([3], 3) ? creep
   Call: (12) _11244 is 2+3 ? creep
   Exit: (12) 5 is 2+3 ? creep
   Exit: (11) somma([2, 3], 5) ? creep
   Call: (11) _9998 is 1+5 ? creep
   Exit: (11) 6 is 1+5 ? creep
   Exit: (10) somma([1, 2, 3], 6) ? creep
Res = 6.

?- somma([1,2,3], 6).
true.

La somma è 6? Si!

?- somma([1,2,3], 19).
false.

La somma è 19? no!

*/

% proviamo ora a fare il prodotto
prodottoOld([], 0).
prodottoOld([Head|Tail], Res) :-
    prodottoOld(Tail, ProdTail),
    Res is Head * ProdTail.

% se mettessimo come caso base (prodotto di una lista senza elementi) 0, otterremmo 0 per ogni lista in input (anche con dei numeri e non vuota)
% se mettessimo 1 invece non andrebbe bene perchè il prodotto di una lista vuota non è 1!!!

% non è scritto da nessuna parte che dobbiamo avere un SOLO caso base ed un SOLO caso induttivo!
% Possiamo scriverne di più!

prodotto([], 0).
prodotto([X], X).   % se la lista ha un solo elemento, il prodotto è uguale proprio a quell'elemento
prodotto([Head|Tail], Res) :-
    prodotto(Tail, ProdTail),
    Res is Head * ProdTail.

% definisco il caso in cui la lista ha un solo elemento!

/*
Facciamo attenzione ad una cosa!
?- prodotto([1,2,3], Res).
Res = 6 ;
Res = 0.

?- prodotto([1,2,3], 6).
true .

?- prodotto([1,2,3], 0).
true.

Noi non vogliamo true!

Cosa succede? 

[trace]  ?- prodotto([1,2,3], 0).
   Call: (10) prodotto([1, 2, 3], 0) ? creep
   Call: (11) prodotto([2, 3], _19712) ? creep
   Call: (12) prodotto([3], _20468) ? creep
   Exit: (12) prodotto([3], 3) ? creep
   Call: (12) _19712 is 2*3 ? creep
   Exit: (12) 6 is 2*3 ? creep
   Exit: (11) prodotto([2, 3], 6) ? creep
   Call: (11) 0 is 1*6 ? creep
   Fail: (11) 0 is 1*6 ? creep
   Redo: (12) prodotto([3], _20468) ? creep
   Call: (13) prodotto([], _26514) ? creep
   Exit: (13) prodotto([], 0) ? creep
   Call: (13) _20468 is 3*0 ? creep
   Exit: (13) 0 is 3*0 ? creep
   Exit: (12) prodotto([3], 0) ? creep
   Call: (12) _19712 is 2*0 ? creep
   Exit: (12) 0 is 2*0 ? creep
   Exit: (11) prodotto([2, 3], 0) ? creep
   Call: (11) 0 is 1*0 ? creep
   Exit: (11) 0 is 1*0 ? creep
   Exit: (10) prodotto([1, 2, 3], 0) ? creep
true.

Per risolvere questo problema l'idea è rendere mutuamente esclusivi i due casi base dalla terza clausola.

Se applichiamo la regola prodotto([X], X)., non vogliamo che sia applicabile anche la seguente!

[Head|Tail] = [3].

Head = 3,
Tail = [].

La regola prodotto([Head|Tail], Res) si applica anche a liste con un solo elemento, facendo poi la chiamata ricorsiva sulla lista vuota.

Non non vogliamo ciò!
*/

prodottoCorretto([], 0).
prodottoCorretto([X], X):-!.   % si aggiunge: !. se l'interprete incontra !, se aveva dei punti di backtracking per quel predicato, li taglia. Se aveva altre strade da esplorare (in caso di fallimento) non ci passa!
prodottoCorretto([Head|Tail], Res) :-
    prodottoCorretto(Tail, ProdTail),
    Res is Head * ProdTail.

prodottoV2([], 0).
prodottoV2([X], X).
prodottoV2([Head|Tail], Res) :-
    %applichiamo una guardia
    length(Tail,N),
    N > 0,  % se la lunghezza di Tail è maggiore di 0 (ovvero la Tail non è la lista vuota), allora vado avanti con le chiamate
    prodottoV2(Tail, ProdTail),
    Res is Head * ProdTail.

% esercizio: proviamo a determinare se un elemento appartiene (anche in prodondità) ad una lista.
% per esempio con member(23, [11,5,[45,23],78]). vogliamo ottenere true

% deepMember(X, [X|_]).   % usiamo il don't care "_"per dire che non ci interessa esattamente quel valore
                        % a noi in questo caso interessa cercare X in una lista che ha proprio X come primo elemento
deepMember(X, L) :- member(X, L).    % si controlla se X appartiene alla lista L
deepMember(X, L) :-
    member(SubList, L), % questa member cerca è soddisfatta se c'è un elemento che è membro della lista, e guardare se all'interno di esso è presente X
    deepMember(X,SubList).  % quando viene richiamato deepMember verrano riconsiderate tutte le possibili alternative


% esercizio: data una lista vogliamo restituire l'inverso di una lista (in questo caso non in profondità)
% input: [1,2,[3,4],5] -> output: [5, [3,4], 2, 1]

% inverti(+Lista, ?ListaInvertita)
inverti([], []).
%inverti([X], [X]).
inverti([Head|Tail], Res) :-
    inverti(Tail, InvTail),
    append(InvTail, [Head], Res).   % append di InvTail e Head che viene messo in Res

% questa soluzione non è il massimo dell'efficienza!
% se il nostroagente intelligente usasse questa soluzione poche volte andrebbe bene, ma se venisse usata tantissime volte sarebbe troppo costoso!

% scriviamo una versine ottimizzata
% invertiOpt(+Lista, ?ListaInvertita)
invertiOpt(Lista, ListaInversa):-inv(Lista, [], ListaInversa).   % uso il secondo argomento per costruire via via la lista inversa

inv([], Temp, Temp).    % quando non ho più nulla da invertire, la mia lista da restituire è proprio Temp
inv([Head|Tail], Temp, Res) :-
    inv(Tail, [Head|Temp], Res).


/*

Costruisco la lista invertita man mano che scendo in profondità!

1 | 2 3 4 5
    [1] -> 2 | 3 4 5
        [2, 1] -> 3 | 4 5
            [3, 2, 1] -> 4 | 5
                [4, 3, 2, 1] -> 5 | []
                    [5, 4, 3, 2, 1] -> []

*/
