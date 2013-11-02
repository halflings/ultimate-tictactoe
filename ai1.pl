% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M, J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
spoilWin(N, M, J) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).



% Priorities:
% 1. Play a cell that makes you win the game (1024)
% 2. (NOT IMPLEMENTED) Avoid enabling the other player to win the game (512)
% 3. (NOT IMPLEMENTED) Play on a grid that if won, would make you win the game (256)
% 4. Avoid going on a grid that has been won (weight : 128)
% 5. Avoid going on a grid where the next player can win in one move  (64)
% 6. Spoil a win in the current grid (32)
% 7. Win the current grid (16)
% 8. Avoid going on a grid where you need one extra move to win (8)
% 9. Go on a grid where the other player never played (4)
% 10. Play a "good" grid (based on its 'weight') (weight up to 3)

nextMove(N, M, J) :- bestCell(N, M, J, _), !.
bestCell(N, M, J, W) :- playableCell(N, M), cellWeight(N, M, J, W), not(biggerWeight(J, W)), !.
biggerWeight(J, W) :- playableCell(XN, XM), cellWeight(XN, XM, J, XW), XW > W.

cellWeight(N, M, J, W) :- baseWeight(M, W8), emptyGridWeight(M, J, W7), avoidSpoiledWinWeight(M, J, W6),
    winWeight(N, M, J, W5), spoilWinWeight(N, M, J, W4), avoidWinWeight(M, J, W3), avoidWonWeight(M, W2), ultimateMoveWeight(N,M,J,W1),
  	W is W1 + W2 + W3 + W4 + W5 + W6 + W7 + W8, !.

baseWeight(M, 1) :- member(M, [1,3,7,9]).
baseWeight(M, 2) :- member(M, [2,4,6,8]).
baseWeight(5, 3).

emptyGridWeight(N, J, 4) :- NextJ is 3 - J, gameField(F), nth1(N, F, G), count(G, NextJ, 0).
emptyGridWeight(_, _, 0).

avoidSpoiledWinWeight(N, J, 8) :- not(isWinningMove(N, _, J)). 
avoidSpoiledWinWeight(_, _, 0).

winWeight(N, M, J, 16) :- isWinningMove(N, M, J).
winWeight(_, _, _, 0).

spoilWinWeight(N, M, J, 32) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).
spoilWinWeight(_, _, _, 0).

avoidWinWeight(M, J, 64) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
avoidWinWeight(_, _, 0).

% TODO : Fix fieldState
avoidWonWeight(M,128) :- fieldState(M, S, _), S = 0.
avoidWonWeight(_,0).

% TODO : Add the predicates that aren't implemented yet

ultimateMoveWeight(N,M,J,1024) :- isWinningMove(N,M,J),winFieldInOneMove(N,J,_).
ultimateMoveWeight(_,_,_,0).

%not Interface tested
winGameIfPlay(N,M,J,1024) :- getGridsState([X1,X2,X3,X4,X5,X6,X7,X8,X9]), isWinning(J,X1,X2,X3,X4,X5,X6,X7,X8,X9,N), isWinningMove(N,M,J).
winGameIfPlay(_,_,_,0).

%not yet tested
isWinningGrid(N,J,256) : - getGridsState([X1,X2,X3,X4,X5,X6,X7,X8,X9]), isWinning(J,X1,X2,X3,X4,X5,X6,X7,X8,X9,N).