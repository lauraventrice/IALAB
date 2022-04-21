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

% ricordiamoci che ogni giornata deve avere 3 PARTITE (in questo caso sno 6 squadre, nel campionato grande saranno 10 partite ogni giornata (19 di andata 1 19 di ritorno))
partitePerGiornata(1..3).

% ad ogni giornata devono essere assegnate 3 partite (in questo caso abbiamo 6 squadre)
3 {partita(G, Partita) : partitePerGiornata(Partita)} 3 :- giornata(G).

% ad ogni partita deve essere associata un solo fatto informazioniPartita 
1 {informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraOspite) : citta(Citta), squadra(SquadraCasa), squadra(SquadraOspite)} 1 :- partita(G, Partita).

% non possiamo avere partite in cui la squadra di casa è uguale alla squadra ospite
:- informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraOspite), SquadraCasa == SquadraOspite.    

% non possiamo avere partite in cui la squadra di casa ha una città diversa rispetto a quella in cui si gioca la partita
:- informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraOspite), squadraInCitta(SquadraCasa, CittaSquadra), Citta <> CittaSquadra.

% non possiamo avere due partite diverse nella stessa giornata che si giocano nella stessa città
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), G1 == G2, Partita1 <> Partita2, Citta1 == Citta2.

% non possiamo avere partite in giornate diverse in cui la squadra di casa e la squadra in trasferta sono uguali per entrambe le partite (dovrò avere inter-juve una volta e poi juve-inter)
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), G1 <> G2, SquadraCasa1 == SquadraCasa2, SquadraOspite1 == SquadraOspite2.

% una squadra non può giocare due partite diverse nella stessa giornata
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), G1 == G2, Partita1 <> Partita2, SquadraCasa1 == SquadraCasa2.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), G1 == G2, Partita1 <> Partita2, SquadraCasa1 == SquadraOspite2.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), G1 == G2, Partita1 <> Partita2, SquadraOspite1 == SquadraOspite2.

% gestione di partite di andata e ritorno
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), SquadraCasa1==SquadraOspite2, SquadraCasa2==SquadraOspite1, G1 < 5, G2 < 5.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa2, SquadraOspite2), SquadraCasa1==SquadraOspite2, SquadraCasa2==SquadraOspite1, G1 > 5, G2 > 5.
