:- ['regole.pl', 'dominio.pl'].

start:-
    ida(S),
    write(S).
  
  ida(S):-
      iniziale(S),
      heuristic_1_wrapper(S, InitialThreshold),
      idastar(S, Sol, [S], 0, InitialThreshold),
      write("\n"), write(Sol).
  
  idastar(S, Sol, VisitedNodes, PathCostS, Threshold):-
      ida_search(S, Sol, VisitedNodes, PathCostS, Threshold);
      findall(FS, ida_node(_, FS), ThresholdList),
      exclude(>=(Threshold), ThresholdList, OverThresholdList),
      sort(OverThresholdList, SortedTList),
      nth0(0, SortedTList, NewThreshold),
      retractall(ida_node(_, _)),
      idastar(S, Sol, VisitedNodes, 0, NewThreshold).
  
  % ###################################################
  % ida_search/5 predicate provides the IDA* search.
  % ###################################################
  ida_search(S, [], _, _, _):-
      finale(S).
  ida_search(S, [Action|OtherActions], VisitedNodes, PathCostS, Threshold):-
      applicabile(Action, S),
      trasforma(Action, S, NewS), 
      \+member(NewS, VisitedNodes),
      PathCostNewS is PathCostS + 1,
      heuristic_1_wrapper(NewS, HeuristicNewState),
      FNewS is PathCostNewS + HeuristicNewState,
      assert(ida_node(NewS, FNewS)),
      FNewS =< Threshold,
      ida_search(NewS, OtherActions, [NewS|VisitedNodes], PathCostNewS, Threshold).