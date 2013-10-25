% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M, J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
spoilWin(N, M, J) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).



% Priorities:
% 1. (NOT IMPLEMENTED) Play a cell that makes you win the game (weight : 128)
% 2. Avoid going on a grid that have been won (weight: 64)
% 3. Avoid going on a grid where the next player can win in one move (weight: 32) 
% 4. Spoil a win in the current grid (weight: 3 + 4 + 8 + 1 = 16)
% 5. Win the current grid (weight: 3 + 4 + 1 = 8)
% 6. (NOT IMPLEMENTED) Go on a grid where the other player never played (weight: 4)
% 7. Play a "good" grid (based on its 'weight') (weight up to 3)

nextMove(N, M, J) :- bestCell(N, M, J, _), !.
bestCell(N, M, J, W) :- playableCell(N, M), cellWeight(N, M, J, W), not(biggerWeight(J, W)), !.
biggerWeight(J, W) :- playableCell(XN, XM), cellWeight(XN, XM, J, XW), XW > W.

cellWeight(N, M, J, W) :- baseWeight(M, W1), winWeight(N, M, J, W2), spoilWinWeight(N, M, J, W3), avoidWinWeight(N, M, J, W4),
                          avoidWonWeight(N, M, J, W5), W is W1 + W2 + W3 + W4 + W5.

baseWeight(M, 1) :- member(M, [1,3,7,9]).
baseWeight(M, 2) :- member(M, [2,4,6,8]).
baseWeight(5, 3).

winWeight(N, M, J, 8) :- isWinningMove(N, M, J), !.
winWeight(_, _, _, 0).

spoilWinWeight(N, M, J, 16) :- NextJ is 3 - J, isWinningMove(N, M, NextJ), !.
spoilWinWeight(_, _, _, 0).

avoidWinWeight(_, M, J, 32) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)), !.
avoidWinWeight(_, _, _, 0).

% TODO : Fix fieldState
avoidWonWeight(_, M, _, 64) :- fieldState(M, W, _), W = 0, !.
avoidWonWeight(_, _, _, 0).