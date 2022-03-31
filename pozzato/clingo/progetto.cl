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
