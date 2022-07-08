% algoritmo IDA* che utilizza l'euristica 1, ovvero il numero di tessere fuori posto.

:-['dominio.pl', 'heuristic1.pl', 'regole.pl'].

ida_wrapperV1(MoveList):-
    iniziale(S),
    heuristic_1_wrapper(S, InitialThreshold),
    ida_star_loopV1(S, MoveList, [S], 0, InitialThreshold),
    length(MoveList, N),
    write("\nLista azioni: "), write(MoveList), write("\nNumero mosse: "), write(N).

ida_star_loopV1(InitialS, MoveList, Visited, G, Bound) :-
    ricercaV1(InitialS, MoveList, Visited, G, Bound), !.

ida_star_loopV1(InitialS, MoveList, Visited, _, Bound) :-
    findall(FS, costoNodo(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(costoNodo(_, _)),
    ida_star_loopV1(InitialS,MoveList, Visited, 0, NewBound).

ricercaV1(S, [], _, _, _):-
    finale(S).
ricercaV1(CurrentS, [Move|MoveList], Visited, G, Bound) :-
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
    assert(costoNodo(NewState, FNewState)),
    write("FNewState: "), write(FNewState), write("\n"),  write("Bound: "), write(Bound),  write("\n"),  write("\n"),
    FNewState =< Bound,
    ricercaV1(NewState, MoveList, [NewState|Visited], GNewState, Bound). 
