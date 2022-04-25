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
    %write(CurrentS),
    applicabile(Move, CurrentS),
    trasforma(Move,CurrentS,NewS),
    \+member(NewS,Visited),
    profondita(NewS,MoveList,[CurrentS|Visited]).


%%%%%%%%%%%%%%%%%%%%
ricercaSoluzioniIterativeDeepening(ListaAzioni):-
    iniziale(CurrentS),
    iterativeDeepening(CurrentS,ListaAzioni,0),
    write(ListaAzioni),nl.

iterativeDeepening(CurrentS,ListaAzioni,ProfonditaCorrente):-
    prof_limitata(CurrentS, ListaAzioni, [],ProfonditaCorrente),
    write("Profondità:"), write(ProfonditaCorrente),nl,
    !.

iterativeDeepening(CurrentS,ListaAzioni,ProfonditaCorrente):-
    ProfonditaNuova is ProfonditaCorrente + 1,
    iterativeDeepening(CurrentS,ListaAzioni,ProfonditaNuova).


%%%%%%%%%%%%%%%%%%%%%

%ITERATIVE DEEPENING
iterative_deepening_wrapper(MoveList, UBound) :-
    iniziale(S),
    iterative_deepening(S, MoveList, 1, UBound).

iterative_deepening(CurrentS, _, _, _) :-
    finale(CurrentS),
    write("Lo stato è finale\n"), !.
iterative_deepening(_, _, LBound, UBound) :-
    LBound == UBound,
    write("Siamo arrivati all'upper bound\n"), !.
iterative_deepening(_, MoveList, LBound, UBound) :-
    write("Siamo qua 1\n"),
    LBound < UBound,
    write("Siamo qua 2\n"),
    NewLBound is LBound + 1,
    write("Siamo qua 3\n"),
    \+cerca_soluzione_limitata(MoveList, LBound), 
    finale(S),
    iterative_deepening(S, MoveList, NewLBound, UBound).

% start:-
%     id(S, 14),
%     write(S).

id(Sol, UBound):-
    iniziale(S),
    length(_, L),
    L =< UBound,
    write("Depth is "), write(L), write("\n"),
    prof_limitata(S, Sol, [S], L),
    write("\n"),
    write(Sol).


%VISITA IN PROFONDITà LIMITATA
% cerca_soluzione_limitata(-MoveList,+Limit)
cerca_soluzione_limitata(MoveList, Bound):-
    iniziale(InitialS),
    prof_limitata(InitialS,MoveList,[],Bound).

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

% per eseguire: ida_star_wrapper(MoveList).
ida_star_wrapper(MoveList) :-
    iniziale(InitialS),
    ida_star(InitialS, MoveList, [InitialS]),
    write(MoveList).

ida_star(InitialS, MoveList, Visited):-
    heuristic_1_wrapper(InitialS, Bound), 
    \+ida_star_loop(InitialS, MoveList, Visited, 0, Bound),
    write("\n"), write(MoveList).   % se mettiamo una negazione per fallimento otteniamo true


%%%%

ida_wrapper(ListaAzioni):-
    iniziale(S),
    heuristic_1_wrapper(S, InitialThreshold),
    ida_star_loop(S, ListaAzioni, [S], 0, InitialThreshold),
    write("\n"), write(ListaAzioni).

ida_star_loop(InitialS, MoveList, Visited, G, Bound) :-
    ricerca(InitialS, MoveList, Visited, G, Bound), !.

ida_star_loop(InitialS, MoveList, Visited, _, Bound) :-
    %\+ricerca(InitialS, MoveList, Visited, G, Bound),
    findall(FS, costoNodo(_, FS), CostList),
    exclude(>=(Bound), CostList, OverCostList),
    sort(OverCostList, SortedOverCostList), 
    nth0(0, SortedOverCostList, NewBound),
    retractall(costoNodo(_, _)),
    ida_star_loop(InitialS,MoveList, Visited, 0, NewBound).

ricerca(S, [], _, _, _):-
    finale(S),
    write("LO STATO E' FINALE!\n").
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
    assert(costoNodo(NewState, FNewState)),  % aggiunto
    write("FNewState: "), write(FNewState), write("\n"),  write("Bound: "), write(Bound),  write("\n"),  write("\n"),
    FNewState =< Bound,
    ricerca(NewState, MoveList, [NewState|Visited], GNewState, Bound). 

