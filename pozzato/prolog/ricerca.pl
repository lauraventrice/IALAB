%VISITA IN PROFONDITà BASIC

% cerca_soluzione(-MoveList)
cerca_soluzione(MoveList) :-
    iniziale(InitialS),
    profondita(InitialS, MoveList, []).

% profondita(CurrentState, MoveList, VisitatedStates)
profondita(CurrentS, [], _):-
    finale(CurrentS), !.
profondita(CurrentS,[Move|MoveList],Visited):-
    write(CurrentS),
    applicabile(Move, CurrentS),
    trasforma(Move,CurrentS,NewS),
    \+member(NewS,Visited),
    profondita(NewS,MoveList,[CurrentS|Visited]).


%ITERATIVE DEEPENING
iterative_deepening(_, LBound, UBound) :-
    LBound == UBound, !.
iterative_deepening(MoveList, LBound, UBound) :-
    LBound < UBound,
    NewLBound is LBound + 1,
    \+cerca_soluzione_limitata(MoveList, LBound), 
    iterative_deepening(MoveList, NewLBound, UBound).


%VISITA IN PROFONDITà LIMITATA
% cerca_soluzione_limitata(-MoveList,+Limit)
cerca_soluzione_limitata(MoveList, Bound):-
    iniziale(InitialS),
    prof_limitata(InitialS,MoveList,[],Bound).

% prof_limitata(CurrentS, MoveListAzioni, Visited, Bound)
prof_limitata(CurrentS,[],_,_):-
    finale(CurrentS),!.
prof_limitata(CurrentS, [Move|MoveList], Visited, Bound):-
    applicabile(Move, CurrentS),
    trasforma(Move, CurrentS, NewS),
    \+member(NewS, Visited),
    Bound>0,
    NewBound is Bound-1,
    prof_limitata(NewS, MoveList, [CurrentS|Visited], NewBound).