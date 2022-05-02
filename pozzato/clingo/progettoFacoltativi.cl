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
squadraInCitta(genoa, genova).  % derby sampdoria e genoa
squadraInCitta(inter, milano). % derby inter e milan
squadraInCitta(juventus, torino). % derby juve e torino
squadraInCitta(lazio, roma). % derby roma e lazio
squadraInCitta(milan, milano). % derby inter e milan
squadraInCitta(napoli, napoli).
squadraInCitta(roma, roma). % derby roma e lazio
squadraInCitta(salernitana, salerno).
squadraInCitta(sampdoria, genova)   .% derby sampdoria e genoa
squadraInCitta(sassuolo, sassuolo).
squadraInCitta(spezia, spezia).
squadraInCitta(torino, torino). % derby juve e torino
squadraInCitta(udinese, udine).
squadraInCitta(venezia, venezia).
squadraInCitta(verona, verona).

giornata(1..38).


%tutte le squadre devono giocare l'una contro l'altra due volte e non possiamo avere partite in cui la squadra di casa è uguale alla squadra ospite
19 {partita(Squadra1, Squadra2) : squadra(Squadra2), Squadra1 <> Squadra2} 19:- squadra(Squadra1). 

%ogni partita deve essere assegnata ad una giornata
1 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : giornata(G), not assegnaAGiornata(G, SquadraCasa, Squadra2)} 1 :- partita(SquadraCasa, SquadraOspite), partita(SquadraCasa, Squadra2),  Squadra2 <> SquadraOspite.


%3 partite per giornata
10 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : partita(SquadraCasa, SquadraOspite)} 10 :- giornata(G).

% una squadra non può giocare due partite diverse nella stessa giornata
:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra1), Squadra2 <> Squadra3.
:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra2), Squadra1 <> Squadra3.

% non possiamo avere due partite diverse nella stessa giornata che si giocano nella stessa città
:- assegnaAGiornata(G, SquadraCasa1, SquadraOspite1), assegnaAGiornata(G, SquadraCasa2, SquadraOspite2), SquadraOspite1 <> SquadraOspite2, squadraInCitta(SquadraCasa1, Citta), squadraInCitta(SquadraCasa2, Citta).

:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 <= 19, G2 <= 19.
:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 > 19, G2 > 19.

%versione con 4 derby: poco piu' di un minuto

%FACOLTATIVI ---------------------------------------------------------------------------------------------------

% distanza di 10 partite tra andata e ritorno 
:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 > 19, G2 <= 19, G1-G2 < 10.
:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 <= 19, G2 >= 19, G2-G1 < 10.

% non si possono giocare due partite di seguito in casa o fuori casa 
%:- assegnaAGiornata(G, Squadra1, Squadra2), assegnaAGiornata(G1, Squadra1, Squadra3), G == G1 + 1.
%:- assegnaAGiornata(G, Squadra2, Squadra1), assegnaAGiornata(G1, Squadra3, Squadra1), G == G1 + 1.

#show assegnaAGiornata/3.