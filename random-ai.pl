randomChoice([], []).
randomChoice(List, Elt) :- length(List, Length), random(0, Length, Index), nth0(Index, List, Elt).

nextMove(N, M, _) :- findall([XN, XM], playableCell(XN, XM), R), randomChoice(R, [N, M]).