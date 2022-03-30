% elenco delle squadre del campionato di Serie A
squadra(atalanta; bologna; cagliari; empoli; fiorentina; genoa; inter; juventus; lazio; milan; napoli; roma; salernitana; sampdoria; sassuolo; spezia; torino; udinese; venezia; verona).

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
squadraInCitta(salernitana, napoli).   % o salerno??? cosa vuole il prof?
squadraInCitta(sampdoria, genova).
squadraInCitta(sassuolo, sassuolo).
squadraInCitta(spezia, spezia). % vuole genova il prof?
squadraInCitta(torino, torino).
squadraInCitta(udinese, udine).
squadraInCitta(venezia, venezia).
squadraInCitta(verona, verona).

% NON SONO CONVINTO DI CIO' CHE HO SCRITTO DA QUA IN POI

% vogliamo organizzare le 38 giornate di campionato
giornataAndata(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)
giornataRitorno(1..19). % è come dire giornata(1), giornata(2), ... , giornata(38)

1 {assegna(Squadra, N) : giornataAndata(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di andata.
1 {assegna(Squadra, N) : giornataRitorno(N)} 1 :- squadra(Squadra). % ogni squadra deve essere assegnata ad una sola giornata di ritorno.

% dobbiamo rimuovere i modelli in cui la squara A della citta C gioca l'andata la stesa giornata della squadra B che è della città C
% ad esempio milan e inter non possono giocare la stessa partita entrambe in casa oppure entrambe in casa nella stessa giornata