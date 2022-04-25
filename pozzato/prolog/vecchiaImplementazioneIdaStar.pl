% per eseguire: ida_star_wrapper(MoveList).
ida_star_wrapper(MoveList) :-
    iniziale(InitialS),
    ida_star(InitialS, MoveList, [InitialS]),
    write(MoveList).

ida_star(InitialS, MoveList, Visited):-
    heuristic_1_wrapper(InitialS, Bound), 
    \+ida_star_loop(InitialS, MoveList, Visited, 0, Bound).   % se mettiamo una negazione per fallimento otteniamo true

ida_star_loop(InitialS, MoveList, Visited, G, Bound) :-
    \+ricerca(InitialS, MoveList, Visited, G, Bound),
    findall(FS, costoNodo(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(costoNodo(_, _)),
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
    assert(costoNodo(NewState, FNewState)),
    write("FNewState: "), write(FNewState), write("\n"),  write("Bound: "), write(Bound),  write("\n"),  write("\n"),
    FNewState =< Bound,
    ricerca(NewState, MoveList, [NewState|Visited], GNewState, Bound). 
