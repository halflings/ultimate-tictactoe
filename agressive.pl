:- ['ai.pl'].

cellWeight(N, M, J, W) :- baseWeight(M, W10), winWeight(N, M, J, W7), isWinningGrid(M, J, W3), winGameIfPlay(N,M,J,W1),
  	W is W1 + W3 + W7 + W10, !.

bestCell(N, M, J, W) :- playableCell(N, M), cellWeight(N, M, J, W), not(biggerWeight(J, W)), !.
biggerWeight(J, W) :- playableCell(XN, XM), cellWeight(XN, XM, J, XW), XW > W.

nextMove(N, M, J) :- bestCell(N, M, J, _), !.