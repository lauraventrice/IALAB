% differenza insiemistica tra insieme e insieme B
% elementi che stanno in A e non stanno in B

differenza([], _, []).
differenza([X|Set], B, Res) :-
    member(X, B), differenza(Set, B, Res).
differenza([], _, []).
differenza([X|Set], B, [X|Res]) :-
    \+member(X, B), differenza(Set, B, Res).    % \+member(X, B) : X non appartiene a B

/*
A = [3,4,25]
B = [12,75,3,11]

3 apartiene a B? si! allora non c'è nella differenza insiemistica.
*/

/*
NB!!! Se c'è un goal per negazione (negazione per fallimento) l'interprete cerca di dimostrare il goal senza negazione e poi ribalta il risultato!

[trace]  ?- \+member(2,[1,3,4]).
   Call: (11) lists:member(2, [1, 3, 4]) ? creep
   Fail: (11) lists:member(2, [1, 3, 4]) ? creep
true.

Per dimostrare !G cerca di dimostrare G e ribalta il risultato!

?- differenza([ciao,23,45,[a,e,i,o,u]],[45,ciao,21],R).
R = [23, [a, e, i, o, u]] ;
R = [23, [a, e, i, o, u]] ;
false.
*/