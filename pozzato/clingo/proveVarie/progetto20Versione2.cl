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
squadraInCitta(salernitana, salerno).
squadraInCitta(sampdoria, genova).
squadraInCitta(sassuolo, sassuolo).
squadraInCitta(spezia, spezia).
squadraInCitta(torino, torino).
squadraInCitta(udinese, udine).
squadraInCitta(venezia, venezia).
squadraInCitta(verona, verona).

giornata(1..38). % è come dire giornata(1), giornata(2), ... , giornata(38)


%tutte le squadre devono giocare l'una contro l'altra due volte e non possiamo avere partite in cui la squadra di casa è uguale alla squadra ospite
19 {partita(Squadra1, Squadra2) : squadra(Squadra2), Squadra1 <> Squadra2} 19:- squadra(Squadra1). %ADESSO HO TUTTE LE PARTITE CREATE TOTALI

%ogni partita deve essere assegnata ad una giornata
1 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : giornata(G) } :- partita(SquadraCasa, SquadraOspite).

%3 partite per giornata
10 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : partita(SquadraCasa, SquadraOspite)} 10 :- giornata(G).

% una squadra non può giocare due partite diverse nella stessa giornata

:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra1), Squadra1 <> Squadra2, Squadra2 <> Squadra3, Squadra1 <> Squadra3.
:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra2), Squadra1 <> Squadra2, Squadra2 <> Squadra3, Squadra1 <> Squadra3.

% non possiamo avere due partite diverse nella stessa giornata che si giocano nella stessa città
:- assegnaAGiornata(G, SquadraCasa1, SquadraOspite1), assegnaAGiornata(G, SquadraCasa2, SquadraOspite2), SquadraCasa1 <> SquadraCasa2, SquadraOspite1 <> SquadraOspite2, squadraInCitta(SquadraCasa1, Citta1), squadraInCitta(SquadraCasa2, Citta2),  Citta1 == Citta2.

:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 <= 19, G2 <= 19.
:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 > 19, G2 > 19.

