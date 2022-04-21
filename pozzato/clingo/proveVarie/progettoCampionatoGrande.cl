% elenco delle squadre del campionato di Serie A
squadra(atalanta; bologna; cagliari; empoli; fiorentina; genoa; inter; juventus; lazio; milan; napoli; roma).

% elenco delle città
citta(bergamo; bologna; cagliari; empoli; firenze; genova; milano; torino; roma; napoli; salerno).
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

% NON SONO CONVINTO DI CIO' CHE HO SCRITTO DA QUA IN POI

giornata(1..22). % è come dire giornata(1), giornata(2), ... , giornata(38)

partitePerGiornata(1..6).

% ad ogni giornata devono essere assegnate 3 partite (in questo caso abbiamo 20 squadre)
6 {partita(G, Partita) : partitePerGiornata(Partita)} 6 :- giornata(G).

% ad ogni partita deve essere associata un solo fatto informazioniPartita 
1 {informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraOspite) : citta(Citta), squadra(SquadraCasa), squadra(SquadraOspite)} 1 :- partita(G, Partita).

% non possiamo avere partite in cui la squadra di casa è uguale alla squadra ospite
:- informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraCasa).    

% non possiamo avere partite in cui la squadra di casa ha una città diversa rispetto a quella in cui si gioca la partita
:- informazioniPartita(G, Partita, Citta, SquadraCasa, SquadraOspite), squadraInCitta(SquadraCasa, CittaSquadra), Citta <> CittaSquadra.

% non possiamo avere due partite diverse nella stessa giornata che si giocano nella stessa città
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G1, Partita2, Citta1, SquadraCasa2, SquadraOspite2), Partita1 <> Partita2.

% non possiamo avere partite in giornate diverse in cui la squadra di casa e la squadra in trasferta sono uguali per entrambe le partite (dovrò avere inter-juve una volta e poi juve-inter)
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraCasa1, SquadraOspite1), G1 <> G2.

% una squadra non può giocare due partite diverse nella stessa giornata
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G1, Partita2, Citta2, SquadraCasa1, SquadraOspite2), Partita1 <> Partita2.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G1, Partita2, Citta2, SquadraCasa2, SquadraCasa1), Partita1 <> Partita2.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G1, Partita2, Citta2, SquadraCasa2, SquadraOspite1), Partita1 <> Partita2.

% gestione di partite di andata e ritorno
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraOspite1, SquadraCasa1), G1 < 11, G2 < 11.
:- informazioniPartita(G1, Partita1, Citta1, SquadraCasa1, SquadraOspite1), informazioniPartita(G2, Partita2, Citta2, SquadraOspite1, SquadraCasa1), G1 > 11, G2 > 11.
