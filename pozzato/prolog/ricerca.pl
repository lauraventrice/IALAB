:- ['regole.pl', 'dominio.pl'].

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
% iterative_deepening_wrapper(MoveList, UBound) :-
%     iterative_deepening(MoveList, 1, UBound).

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

% heuristic_1(CurrentState, FinalState)
% i due stati sono rappresentati da liste di lunghezza uguale
% ATTENZIONE: contiamo anche la tessera vuota (CHISSà?)
heuristic_1_wrapper_fake(_, Result) :-
    Result is 0.

heuristic_1_wrapper(CurrentState, Result) :-
    finale(FinalState),
    heuristic_1(CurrentState, FinalState, 0, Result).

heuristic_1([], [], Count, Result) :-
    Result is Count.
heuristic_1([HeadCS|TailCS], [HeadFS|TailFS], Count, NewResult) :- 
    HeadCS \== HeadFS, !,
    NewCount is Count + 1,
    heuristic_1(TailCS, TailFS, NewCount, NewResult).
heuristic_1([_|TailCS], [_|TailFS], Count, Result) :-
    heuristic_1(TailCS, TailFS, Count, Result).


ida_star_wrapper(MoveList) :-
    iniziale(InitialS),
    ida_star(InitialS, MoveList, [InitialS]),
    write(MoveList).

ida_star(InitialS, MoveList, Visited):-
    heuristic_1_wrapper(InitialS, Bound), 
    \+ida_star_loop(InitialS, MoveList, Visited, 0, Bound).   % se mettiamo una negazione per fallimento otteniamo true

ida_star_loop(InitialS, MoveList, Visited, G, Bound) :-
    \+ricerca(InitialS, MoveList, Visited, G, Bound),
    findall(FS, ida_node(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(ida_node(_, _)),
    ida_star_loop(InitialS,MoveList, Visited, 0, NewBound).

ricerca(S, [], _, _, _):-
    finale(S),
    write("LO STATO E' FINALE!\n"), !.
ricerca(CurrentS, [Move|MoveList], Visited, G, Bound) :-
    write("CurrentS: "), write(CurrentS), write("\n"),
    applicabile(Move, CurrentS),
    write("Move: "), write(Move), write("\n"),
    trasforma(Move,CurrentS,NewState),
    \+member(NewState,Visited),
    write("NewState: "), write(NewState), write("\n"),
    GNewState is G+1,
    heuristic_1_wrapper(NewState, HeuristicNewState),
    write("HeuristicNewState: "), write(HeuristicNewState), write("\n"), 
    FNewState is GNewState + HeuristicNewState,
    assert(ida_node(NewState, FNewState)),  % aggiunto
    write("FNewState: "), write(FNewState), write("\n"),  write("Bound: "), write(Bound),  write("\n"),  write("\n"),
    FNewState =< Bound,
    ricerca(NewState, MoveList, [NewState|Visited], GNewState, Bound). 

