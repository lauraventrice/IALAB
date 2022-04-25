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

giornata(1..10). % è come dire giornata(1), giornata(2), ... , giornata(10)

%tutte le squadre devono giocare l'una contro l'altra due volte e non possiamo avere partite in cui la squadra di casa è uguale alla squadra ospite
5 {partita(Squadra1, Squadra2) : squadra(Squadra2), Squadra1 <> Squadra2} 5:- squadra(Squadra1). 

%ogni partita deve essere assegnata ad una giornata
1 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : giornata(G) } :- partita(SquadraCasa, SquadraOspite).

%3 partite per giornata
3 {assegnaAGiornata(G, SquadraCasa, SquadraOspite) : partita(SquadraCasa, SquadraOspite)} 3 :- giornata(G).

% una squadra non può giocare due partite diverse nella stessa giornata

:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra1, Squadra3), Squadra2 <> Squadra3.
:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra1), Squadra2 <> Squadra3.
:- assegnaAGiornata(G,Squadra1, Squadra2), assegnaAGiornata(G, Squadra3, Squadra2), Squadra1 <> Squadra3.

% non possiamo avere due partite diverse nella stessa giornata che si giocano nella stessa città
:- assegnaAGiornata(G, SquadraCasa1, SquadraOspite1), assegnaAGiornata(G, SquadraCasa2, SquadraOspite2), SquadraOspite1 <> SquadraOspite2, squadraInCitta(SquadraCasa1, Citta), squadraInCitta(SquadraCasa2, Citta).

:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 <= 5, G2 <= 5.
:- assegnaAGiornata(G1, Squadra1, Squadra2), assegnaAGiornata(G2, Squadra2, Squadra1), G1 > 5, G2 > 5.

