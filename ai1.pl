% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M, J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
spoilWin(N, M, J) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).

weight(M, 1) :- member(M, [1,3,7,9]).
weight(M, 2) :- member(M, [2,4,6,8]).
weight(5, 3).

% TODO : Do a dynamic weights system to be able to scale this method

% Priorities:
% 1. Avoid going on a grid that have been won
% 2. Avoid going on a grid where the next player can win in one move 
% 3. Spoil a win in the current grid
% 4. Win the current grid
% 5. (NOT IMPLEMENTED) Go on a grid where the other player never played
% 5. Play a "good" grid (based on its 'weight')
% 6. Play any grid


% Avoid loss
% Avoid going on a grid that have been won
% Win the current grid
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), isWinningMove(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), isWinningMove(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), isWinningMove(N, M, J), weight(M, 3).

% Avoid loss
% Avoid going on a grid that have been won
% Spoil a win
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), spoilWin(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), spoilWin(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), spoilWin(N, M, J), weight(M, 3).

% Avoid loss
% Avoid going on a grid that have been won
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(M, 0, _), weight(M, 3).


% Avoid loss
% Win the current grid
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), isWinningMove(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), isWinningMove(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), isWinningMove(N, M, J), weight(M, 3).

% Avoid loss
% Win the current grid
nextMove(M, M, J) :- playableCell(M, M), spoilWin(M, M, J), isWinningMove(M, M, J), weight(M, 1).
nextMove(M, M, J) :- playableCell(M, M), spoilWin(M, M, J), isWinningMove(M, M, J), weight(M, 2).
nextMove(M, M, J) :- playableCell(M, M), spoilWin(M, M, J), isWinningMove(M, M, J), weight(M, 3).

% Avoid loss 
% Spoil a future win from the other player
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 3).

% Avoid loss
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 3).

% Win the current grid
nextMove(N, M, J) :- playableCell(N,M), isWinningMove(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), isWinningMove(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), isWinningMove(N, M, J), weight(M, 3).

% Play the best cell
nextMove(N, M, _) :- playableCell(N,M), weight(M, 1).
nextMove(N, M, _) :- playableCell(N,M), weight(M, 2).
nextMove(N, M, _) :- playableCell(N,M), weight(M, 3).



% Priorities:
% 1. Avoid going on a grid that have been won (weight: 3 + 4 + 8 + 16 + 32 + 1 = 64)
% 2. Avoid going on a grid where the next player can win in one move (weight: 3 + 4 + 8 + 16 + 1 = 32) 
% 3. Spoil a win in the current grid (weight: 3 + 4 + 8 + 1 = 16)
% 4. Win the current grid (weight: 3 + 4 + 1 = 8)
% 5. (NOT IMPLEMENTED) Go on a grid where the other player never played (weight: 4)
% 6. Play a "good" grid (based on its 'weight') (weight up to 3)


cellWeight(N, M, J, W) :- weight(M, W1), winWeight(N, M, J, W2), spoilWeight(N, M, J, W3), avoidWinWeight(N, M, J, W4),
                          avoidWonWeight(N, M, J, W5), W is W1 + W2 + W3 + W4 + W5, !.

winWeight(N, M, J, 8) :- isWinningMove(N, M, J), !.
winWeight(_, _, _, 0).

spoilWeight(N, M, J, 16) :- NextJ is 3 - J, isWinningMove(N, M, NextJ), !.
spoilWeight(_, _, _, 0).

avoidWinWeight(_, M, J, 32) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)), !.
avoidWinWeight(_, _, _, 0).

avoidWonWeight(_, M, _, 64) :- fieldState(M, 0, _), !.
avoidWonWeight(_, _, _, 0).