% algoritmo IDA* che utilizza l'euristica 2, ovvero il numero si inversioni nella lista rappresentante lo stato.

ida_wrapperV2(MoveList):-
    iniziale(S),
    heuristic_2_wrapper(S, InitialThreshold),
    ida_star_loopV2(S, MoveList, [S], 0, InitialThreshold),
    write("\nLista azioni: "), write(MoveList).

ida_star_loopV2(InitialS, MoveList, Visited, G, Bound) :-
    ricercaV2(InitialS, MoveList, Visited, G, Bound), !.

ida_star_loopV2(InitialS, MoveList, Visited, _, Bound) :-
    %\+ricerca(InitialS, MoveList, Visited, G, Bound),
    findall(FS, costoNodo(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(costoNodo(_, _)),
    ida_star_loopV2(InitialS,MoveList, Visited, 0, NewBound).

ricercaV2(S, [], _, _, _):-
    finale(S).
    %write("LO STATO E' FINALE!\n").
ricercaV2(CurrentS, [Move|MoveList], Visited, G, Bound) :-
    %write("CurrentS: "), write(CurrentS), write("\n"),
    applicabile(Move, CurrentS),
    %write("Move: "), write(Move), write("\n"),
    trasforma(Move,CurrentS,NewState),
    \+member(NewState,Visited),
    %write("NewState: "), write(NewState), write("\n"),
    GNewState is G+1,
    heuristic_2_wrapper(NewState, HeuristicNewState),
    %write("HeuristicNewState: "), write(HeuristicNewState), write("\n"), 
    FNewState is GNewState + HeuristicNewState,
    assert(costoNodo(NewState, FNewState)),  % aggiunto
    %write("FNewState: "), write(FNewState), write("\n"),  write("Bound: "), write(Bound),  write("\n"),  write("\n"),
    FNewState =< Bound,
    ricercaV2(NewState, MoveList, [NewState|Visited], GNewState, Bound). 
