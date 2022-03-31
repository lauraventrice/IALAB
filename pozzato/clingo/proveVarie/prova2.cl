% elenco delle squadre del campionato di Serie A
squadra(inter; juventus; lazio; milan; napoli; bologna).

% elenco delle città
citta(milano; torino; roma; napoli; bologna).

% associazione di ogni squadra alla propria citta
squadraInCitta(inter, milano).
squadraInCitta(juventus, torino).
squadraInCitta(lazio, roma).
squadraInCitta(milan, milano).
squadraInCitta(napoli, napoli).
squadraInCitta(bologna, bologna).

tipo(andata; ritorno).


% NON SONO CONVINTO DI CIO' CHE HO SCRITTO DA QUA IN POI

giornata(1..10). % è come dire giornata(1), giornata(2), ... , giornata(38)


% vogliamo organizzare le 38 giornate di campionato
% giornataAndata(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)
% giornataRitorno(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)

% 1 {assegna(Squadra, N) : giornataAndata(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di andata.
% 1 {assegna(Squadra, N) : giornataRitorno(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di ritorno.

% dobbiamo rimuovere i modelli in cui la squara A della citta C gioca l'andata la stesa giornata della squadra B che è della città C
% ad esempio milan e inter non possono giocare la stessa partita entrambe in casa oppure entrambe in casa nella stessa giornata


% 19 {squadraCasa(G, S) : squadra(S)} 19 :- giornata(G). % ad ogni giornata assegna una sola squadra di casa
% 19 {squadraTasferta(G, S) : squadra(S)} 19 :- giornata(G). % ad ogni giornata assegna una sola squadra in trasferta

partita(1..3).

3 {match(G, P) : partita(P)} 3 :- giornata(G).

1 {tipoMatch(G, P, T) : tipo(T)} 1 :- match(G, P).

1 {gara(G, P, T, C, S1, S2) : citta(C), tipo(T), squadra(S1), squadra(S2)} 1 :- match(G, P).

% 1 {matchSquadraCasa(G, P, S) : squadra(S)} 1 :- match(G, P).
% 1 {matchSquadraOspite(G, P, S) : squadra(S)} 1 :- match(G, P).

:- gara(G, P, T, C, S1, S2), S1 == S2.
:- gara(G1, P1, T1, C1, S11, S21), gara(G2, P2, T2, C2, S12, S22), G1 <> G2, T1 == andata, T2 == andata, S11 == S12, S21 == S22.
:- gara(G, P, T, C, S1, S2), squadraInCitta(S1, C1), C <> C1.
:- gara(G1, P1, T1, C1, S11, S21), T1 == andata, gara(G2, P2, T2, C2, S12, S22), T2 == ritorno, S11 == S12, S21 == S22.

% :- matchInCitta(G, P, C), matchSquadraCasa(G, P, S), squadraInCitta(S, C1), C <> C1.
% :- matchInCitta(G, P, C), matchInCitta(G1, P1, C1), G == G1, C == C1, P <> P1.
% :- matchInCitta(G, P, C), matchSquadraCasa(G, P, S), matchSquadraOspite(G, P, S1), S == S1.

% 3 {giornataCittaSquadraCasa(G, C, S) : squadra(S), citta(C)} 3 :- giornata(G).
% 3 {giornataCittaSquadraTrasferta(G, C, S) : squadra(S), citta(C)} 3 :- giornata(G).

% 1 {giornataCittaSquadraCasa(G, C, S) : giornata(G), citta(C)} 1 :- squadra(S).
% 1 {giornataCittaSquadraTrasferta(G, C, S) : giornata(G), citta(C)} 1 :- squadra(S).

% non vogliamo un odello in cui 
%:- squadraCasa(NumeroGiornata1, Squadra1), squadraCasa(NumeroGiornata2, Squadra2), Squadra1 <> Squadra 2, NumeroGiornata1 == NumeroGiornata2.

%:- partita(G, C1, S1, S2), squadraInCitta(S1, C2), C1 <> C2.
%  :- partita(G, C1, S1, S2), S1 == S2.



%#show giornataCittaSquadraCasa/3.
