% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M, J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
spoilWin(N, M, J) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).



% Priorities:
% 1. Play a cell that makes you win the game (weight : 256)
% 2. Avoid going on a grid that has been won (weight : 128)
% 3. Avoid going on a grid where the next player can win in one move  (weight: 64)
% 4. Spoil a win in the current grid (weight: 32)
% 5. Win the current grid (weight: 3 + 4 + 8 + 1 = 16)
% 6. Avoid going on a grid where you need one extra move to win (weight: 3 + 4 + 1 = 8)
% 7. Go on a grid where the other player never played (weight: 4)
% 8. Play a "good" grid (based on its 'weight') (weight up to 3)

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
avoidWonWeight(M,128) :- fieldState(M, 0, _).
avoidWonWeight(_,0).

ultimateMoveWeight(N,M,J,256) :- isWinningMove(N,M,J),winFieldInOneMove(N,J,_).
ultimateMoveWeight(_,_,_,0).