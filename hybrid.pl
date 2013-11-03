:- ['ai.pl'].

cellWeight(N, M, J, W) :- baseWeight(M, W10), emptyGridWeight(M, J, W9), avoidSpoiledWinWeight(M, J, W8),
    winWeight(N, M, J, W7), spoilWinWeight(N, M, J, W6), avoidWinWeight(M, J, W4), avoidWonWeight(M, W5),
    isWinningGrid(M, J, W3), avoidLosingGame(M, J, W2),  winGameIfPlay(N,M,J,W1),
  	W is W1 + W2 + W3 + W4 + W5 + W6 + W7 + W8 + W9 + W10, !.

bestCell(N, M, J, W) :- playableCell(N, M), cellWeight(N, M, J, W), not(biggerWeight(J, W)), !.
biggerWeight(J, W) :- playableCell(XN, XM), cellWeight(XN, XM, J, XW), XW > W.

nextMove(N, M, J) :- bestCell(N, M, J, _), !.