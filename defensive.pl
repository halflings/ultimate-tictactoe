:- ['ai.pl'].

cellWeight(N, M, J, W) :- emptyGridWeight(M, J, W9), avoidSpoiledWinWeight(M, J, W8),
    spoilWinWeight(N, M, J, W6), avoidWinWeight(M, J, W5), avoidWonWeight(M, W4), avoidLosingGame(M, J, W2),
  	W is W2 + W4 + W5 + W6 + W8 + W9, !.

bestCell(N, M, J, W) :- playableCell(N, M), cellWeight(N, M, J, W), not(biggerWeight(J, W)), !.
biggerWeight(J, W) :- playableCell(XN, XM), cellWeight(XN, XM, J, XW), XW > W.

nextMove(N, M, J) :- bestCell(N, M, J, _), !.