% import degli altri file necessari
:- ['regole.pl', 'dominio.pl', 'heuristic1.pl', 'heuristic2.pl', 'idastarV1.pl', 'idastarV2.pl', 'ricerca.pl'].

% regola per avviare l'algoritmo IDA* con l'eurisitca 1
startIDAstarHeuristic1 :- 
    set_prolog_flag(stack_limit, 3 000 000 000),
    statistics(cputime, TStart),
    write("Tempo di avvio: "), write(TStart), nl,
    ida_wrapperV1(_),
    statistics(cputime, TEnd), nl, nl,
    write("Tempo di fine: "), write(TEnd), nl, nl,
    TotalTime is TEnd - TStart,
    write("Tempo totale di esecuzione: "), write(TotalTime), write(" secondi\n").


% regola per avviare l'algoritmo IDA* con l'euristica 2
startIDAstarHeuristic2 :- 
    statistics(cputime, TStart),
    write("Tempo di avvio: "), write(TStart), nl,
    ida_wrapperV2(_),
    statistics(cputime, TEnd), nl, nl,
    write("Tempo di fine: "), write(TEnd), nl, nl,
    TotalTime is TEnd - TStart,
    write("Tempo totale di esecuzione: "), write(TotalTime), write(" secondi\n"), !.    %NB. se rimuoviamo il cut ci dà due volte la stessa soluzione: questo deve essere dovuto all'implementzione della seconda euristica (numero di inversioni), la quale restituisce per due volte il numero di inversioni.

% regola per avviare l'algoritmo di ricerca in profondità basic
startRicercaProfonditaBasic :- 
    statistics(cputime, TStart),
    write("Tempo di avvio: "), write(TStart), nl,
    cerca_soluzione(_),
    statistics(cputime, TEnd), nl, nl,
    write("Tempo di fine: "), write(TEnd), nl, nl,
    TotalTime is TEnd - TStart,
    write("Tempo totale di esecuzione: "), write(TotalTime), write(" secondi\n").

% regola per avviare l'algoritmo di ricerca in profondità limitata basic
startRicercaProfonditaLimitata :- 
    statistics(cputime, TStart),
    write("Tempo di avvio: "), write(TStart), nl,
    cerca_soluzione_limitata(_, 50),
    statistics(cputime, TEnd), nl, nl,
    write("Tempo di fine: "), write(TEnd), nl, nl,
    TotalTime is TEnd - TStart,
    write("Tempo totale di esecuzione: "), write(TotalTime), write(" secondi\n").

% regola per avviare l'algoritmo di ricerca iterative deepening
startRicercaIterativeDeepening :- 
    statistics(cputime, TStart),
    write("Tempo di avvio: "), write(TStart), nl,
    ricercaSoluzioniIterativeDeepening(_),
    statistics(cputime, TEnd), nl, nl,
    write("Tempo di fine: "), write(TEnd), nl, nl,
    TotalTime is TEnd - TStart,
    write("Tempo totale di esecuzione: "), write(TotalTime), write(" secondi\n").