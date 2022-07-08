% algoritmo IDA* che utilizza l'euristica 2, ovvero il numero si inversioni nella lista rappresentante lo stato.

:-['dominio.pl', 'heuristic2.pl', 'regole.pl'].

ida_wrapperV2(MoveList):-
    iniziale(S),
    heuristic_2_wrapper(S, InitialThreshold),
    ida_star_loopV2(S, MoveList, [S], 0, InitialThreshold),
    write("\nLista azioni: "), write(MoveList), write("\nNumero mosse: "), write(length(MoveList)).

ida_star_loopV2(InitialS, MoveList, Visited, G, Bound) :-
    ricercaV2(InitialS, MoveList, Visited, G, Bound), !.

ida_star_loopV2(InitialS, MoveList, Visited, _, Bound) :-
    findall(FS, costoNodo(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(costoNodo(_, _)),
    ida_star_loopV2(InitialS,MoveList, Visited, 0, NewBound).

ricercaV2(S, [], _, _, _):-
    finale(S).
ricercaV2(CurrentS, [Move|MoveList], Visited, G, Bound) :-
    applicabile(Move, CurrentS),
    trasforma(Move, CurrentS, NewState),
    \+member(NewState, Visited),
    GNewState is G+1,
    heuristic_2_wrapper(NewState, HeuristicNewState),
    FNewState is GNewState + HeuristicNewState,
    assert(costoNodo(NewState, FNewState)),
    FNewState =< Bound,
    ricercaV2(NewState, MoveList, [NewState|Visited], GNewState, Bound). 
