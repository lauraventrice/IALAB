% applicabile(AZ, S)
applicabile(nord, pos(Riga, Colonna)) :-
    Riga > 1,
    RigaSopra is Riga-1,
    \+occupata(pos(RigaSopra, Colonna)).

applicabile(sud,pos(Riga,Colonna)) :-
    num_righe(NRiga),
    Riga<NRiga,
    RigaSopra is Riga+1,
    \+occupata(pos(RigaSopra,Colonna)).

applicabile(ovest,pos(Riga,Colonna)) :-
    Colonna>1,
    ColonnaSinistra is Colonna-1,
    \+occupata(pos(Riga,ColonnaSinistra)).

applicabile(est,pos(Riga,Colonna)) :-
    num_col(NColonna),  %NColonna assume il valore sctitto in num_col nel dominio
    Colonna<NColonna,
    ColonnaSinistra is Colonna+1,
    \+occupata(pos(Riga,ColonnaSinistra)).

% trasforma(AZ, S, S_Nuovo)
trasforma(est, pos(Riga,Colonna), pos(Riga,ColonnaSinistra)) :- ColonnaSinistra is Colonna+1.
trasforma(ovest,pos(Riga,Colonna),pos(Riga,ColonnaSinistra)) :- ColonnaSinistra is Colonna-1.
trasforma(sud,pos(Riga,Colonna),pos(RigaSopra,Colonna)) :- RigaSopra is Riga+1.
trasforma(nord,pos(Riga,Colonna),pos(RigaSopra,Colonna)) :- RigaSopra is Riga-1.

/*
finall è un predicato con 3 argomenti,

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

?- applicabile(Az,pos(1,1)), trasforma(Az, pos(1,1), S).
Az = sud,
S = pos(2, 1) ;
Az = est,
S = pos(1, 2).

*/

/*
?- iniziale(S), applicabile(Az, S), trasforma(Az, S, S1).
S = pos(4, 2),
Az = nord,
S1 = pos(3, 2) ;
S = pos(4, 2),
Az = sud,
S1 = pos(5, 2) ;
S = pos(4, 2),
Az = ovest,
S1 = pos(4, 1) ;
S = pos(4, 2),
Az = est,
S1 = pos(4, 3).

?- iniziale(S), applicabile(Az, S), trasforma(Az, S, S1), finale(S1).
false.

Non c'è nesusna azione che applicata dalla posizione iniziale ci porti allo stato finale

*/

/*
?- iniziale(S), applicabile(Az, S), trasforma(Az, S, S1), applicabile(Az2, S1), trasforma(Az2, S1, S2), finale(S2).
false.

Noi cercheremo di muoverci a passi, cercando di arrivare allo stato finale
*/