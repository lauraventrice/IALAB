% elenco delle squadre del campionato di Serie A
squadra(atalanta; bologna; cagliari; empoli; fiorentina; genoa; inter; juventus; lazio; milan; napoli; roma; salernitana; sampdoria; sassuolo; spezia; torino; udinese; venezia; verona).

% elenco delle città
citta(bergamo; bologna; cagliari; empoli; firenze; genova; milano; torino; roma; napoli; salerno; sassuolo; spezia; udine; venezia; verona).
% associazione di ogni squadra alla propria citta
squadraInCitta(atalanta, bergamo).
squadraInCitta(bologna, bologna).
squadraInCitta(cagliari, cagliari).
squadraInCitta(empoli, empoli).
squadraInCitta(fiorentina, firenze).
squadraInCitta(genoa, genova).
squadraInCitta(inter, milano).
squadraInCitta(juventus, torino).
squadraInCitta(lazio, roma).
squadraInCitta(milan, milano).
squadraInCitta(napoli, napoli).
squadraInCitta(roma, roma).
squadraInCitta(salernitana, salerno).   % o napoli??? cosa vuole il prof? credo voglia salerno perchè nei vincoli dice che ci sono TRE derby (torino, milano e roma)
squadraInCitta(sampdoria, genova).
squadraInCitta(sassuolo, sassuolo).
squadraInCitta(spezia, spezia). % vuole genova il prof?
squadraInCitta(torino, torino).
squadraInCitta(udinese, udine).
squadraInCitta(venezia, venezia).
squadraInCitta(verona, verona).

% NON SONO CONVINTO DI CIO' CHE HO SCRITTO DA QUA IN POI

giornata(1..38). % è come dire giornata(1), giornata(2), ... , giornata(38)


% vogliamo organizzare le 38 giornate di campionato
% giornataAndata(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)
% giornataRitorno(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)

% 1 {assegna(Squadra, N) : giornataAndata(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di andata.
% 1 {assegna(Squadra, N) : giornataRitorno(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di ritorno.

% dobbiamo rimuovere i modelli in cui la squara A della citta C gioca l'andata la stesa giornata della squadra B che è della città C
% ad esempio milan e inter non possono giocare la stessa partita entrambe in casa oppure entrambe in casa nella stessa giornata


% 19 {squadraCasa(G, S) : squadra(S)} 19 :- giornata(G). % ad ogni giornata assegna una sola squadra di casa
% 19 {squadraTasferta(G, S) : squadra(S)} 19 :- giornata(G). % ad ogni giornata assegna una sola squadra in trasferta



1 {giornataCittaSquadraCasa(G, C, S) : squadra(S), citta(C)} 1 :- giornata(G).
1 {giornataCittaSquadraTrasferta(G, C, S) : squadra(S), citta(C)} 1 :- giornata(G).

1 {giornataCittaSquadraCasa(G, C, S) : giornata(G), citta(C)} 1 :- squadra(S).
1 {giornataCittaSquadraTrasferta(G, C, S) : giornata(G), citta(C)} 1 :- squadra(S).

% non vogliamo un odello in cui 
%:- squadraCasa(NumeroGiornata1, Squadra1), squadraCasa(NumeroGiornata2, Squadra2), Squadra1 <> Squadra 2, NumeroGiornata1 == NumeroGiornata2.

:- giornataCittaSquadraCasa(G1, C1, S1), giornataCittaSquadraCasa(G2, C2, S2), G1 == G2, C1 == C2, S1 <> S2, squadraInCitta(S1, C1), squadraInCitta(S2, C2).
:- giornataCittaSquadraCasa(G1, C1, S1), giornataCittaSquadraCasa(G2, C2, S2), G1 == G2 + 1, C1 == C2, S1 == S2.

:- giornataCittaSquadraCasa(G1, C1, S1), giornataCittaSquadraCasa(G2, C2, S2), G1 == G2, C1 <> C2, S1 == S2.


#show giornataCittaSquadraCasa/3.
