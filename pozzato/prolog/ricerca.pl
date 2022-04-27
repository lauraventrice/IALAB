:- ['regole.pl', 'dominio.pl'].

% VISITA IN PROFONDITA' BASIC

% cerca_soluzione(-MoveList)
cerca_soluzione(MoveList) :-
    iniziale(InitialS),
    profondita(InitialS, MoveList, []),
    write("\nLista azioni: "), write(MoveList).

% profondita(CurrentState, MoveList, VisitatedStates)
profondita(CurrentS, [], _):-
    finale(CurrentS), !.
profondita(CurrentS,[Move|MoveList],Visited):-
    applicabile(Move, CurrentS),
    trasforma(Move,CurrentS,NewS),
    \+member(NewS,Visited),
    profondita(NewS,MoveList,[CurrentS|Visited]).


% ITERATIVE DEEPENING
ricercaSoluzioniIterativeDeepening(MoveList):-
    iniziale(CurrentS),
    iterativeDeepening(CurrentS,MoveList,30), %%%%%%%%%%%%%%%%%%%%%%%%
    write("\nLista azioni: "), write(MoveList).

iterativeDeepening(CurrentS,MoveList,ProfonditaCorrente):-
    prof_limitata(CurrentS, MoveList, [],ProfonditaCorrente),
    write("\nProfondità: "), write(ProfonditaCorrente), nl,
    !.

iterativeDeepening(CurrentS,MoveList,ProfonditaCorrente):-
    ProfonditaNuova is ProfonditaCorrente + 1,
    write("\nProfondità: "), write(ProfonditaNuova), nl,
    iterativeDeepening(CurrentS,MoveList,ProfonditaNuova).

%VISITA IN PROFONDITA' LIMITATA
% cerca_soluzione_limitata(-MoveList,+Limit)
cerca_soluzione_limitata(MoveList, Bound):-
    iniziale(InitialS),
    prof_limitata(InitialS,MoveList,[],Bound),
    write("\nLista azioni: "), write(MoveList).

% prof_limitata(CurrentS, MoveListAzioni, Visited, Bound)
prof_limitata(CurrentS,[],_,_):-
    finale(CurrentS), !.
prof_limitata(CurrentS, [Move|MoveList], Visited, Bound):-
    applicabile(Move, CurrentS),
    trasforma(Move, CurrentS, NewS),
    \+member(NewS, Visited),
    Bound>0,
    NewBound is Bound-1,
    prof_limitata(NewS, MoveList, [CurrentS|Visited], NewBound).