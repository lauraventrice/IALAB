% Predicato che conta i numeri positivi in una lista
% [1,2,-3,-2,-3,6,-11,10] deve dare 4

conta_positivi_senza_cut([], 0).
conta_positivi_senza_cut([Head|Tail], P) :-
    Head > 0, conta_positivi_senza_cut(Tail, PTail), P is PTail + 1.
conta_positivi_senza_cut([_|Tail], PTail) :-
    conta_positivi_senza_cut(Tail, PTail).

/*
?- conta_positivi_senza_cut([1,2,-3,-2,-3,6,-11,10], Res).
Res = 4 ;
Res = 3 ;
Res = 3 ;
Res = 2 ;
Res = 3 ;
Res = 2 ;
Res = 2 ;
Res = 1 ;
Res = 3 ;
Res = 2 ;
Res = 2 ;
Res = 1 ;
Res = 2 ;
Res = 1 ;
Res = 1 ;
Res = 0.

Senza il cut il comportamento è questo.
Se noi chiedessimo "è vero che ci sono 0 positivi?" lui risponderebbe di si! (Stessa cosa per 3, per 2 e per 1)
*/

conta_positivi([], 0).
conta_positivi([Head|Tail], P) :-
    Head > 0, !, conta_positivi(Tail, PTail), P is PTail + 1.   %se la head è positiva non ha senso mantenere il punto di backtracking per l'altra strada alternativa! Quindi usiamo il cut.
conta_positivi([_|Tail], PTail) :- 
    conta_positivi(Tail, PTail).

/*
?- conta_positivi([1,2,-3,-2,-3,6,-11,10], Res).
Res = 4.

Non dà nemmeno il ;!
le altre strade sono state tagliate.
*/



% unione tra due insiemi (rappresentati come liste) (per assunzione non hanno elementi duplicati).

unione([], B, B).
unione([X|Set], B, USetB) :-
    member(X, B), !, unione(Set, B, USetB).
% la X sta dentro B, lo aggiungerò dopo

%senza il cut, degli elementi presenti sia in A che in B verrebbero aggiunti più volte all'insieme finale.

%se X si non si trova in B, lo aggiungo subito
unione([X|Set], B, [X|USetB]) :- unione(Set, B, USetB).

/*
?- unione([1,2,3,4],[5,1,2,3,5,6,7,8], Res).
Res = [4, 5, 1, 2, 3, 5, 6, 7, 8].
*/