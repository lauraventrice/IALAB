% cerca_soluzione(-ListaAzioni)
% vogliamo come parametro di output la lista di azioni

cerca_soluzione(ListaAzioni) :-
    iniziale(SIniziale),
    profondita(SIniziale, ListaAzioni, []). % inizialmente la lista dei visitati è vuota

% profondita(StatoCorrente, ListaAzioni, Visitati)
profondita(StatoCorrente, [], _) :-
    finale(StatoCorrente), !.   %se è uno stato finale non considero più le altre alternative
%se voglio più soluzioni non metto il cut (!)

profondita(StatoCorrente, [Az | ListaAzioni], Visitati) :-
    applicabile(Az, StatoCorrente), % cerca un'azione applicabile
    trasforma(Az, StatoCorrente, SNuovo),    % trasforma lo stato corrente in quello nuovo con quell'azione selezionata
    \+member(SNuovo, Visitati),  %se lo stato nuovo non appartiene a quelli già visitati allora possiamo invocare ricorsivamente la nostra ricerca
    profondita(SNuovo, ListaAzioni,[StatoCorrente|Visitati]).   % aggiungiamo lo stato corrente alla lista dei visitati

%?- cerca_soluzione(Lista), write('Lista azioni: '), write(Lista), length(Lista, NumeroPassi).

