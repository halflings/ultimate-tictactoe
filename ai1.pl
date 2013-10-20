% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M,J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
spoilWin(N, M, J) :- NextJ is 3 - J, isWinningMove(N, M, NextJ).
% On essaie de jouer une case pour gagner la grille actuelle
winGrid(N,M,J) :- isWinningMove(N, M, J).

weight(M, 1) :- member(M, [1,3,7,9]).
weight(M, 2) :- member(M, [2,4,6,8]).
weight(5, 3).

% Avoid loss or going on a grid that have been won (== giving all choices to the next player) AND winning
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), winGrid(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), winGrid(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), winGrid(N, M, J), weight(M, 3).

% Avoid loss or going on a grid that have been won (== giving all choices to the next player)
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), fieldState(N, 0, _), weight(M, 3).

% Avoid loss and win the current grid
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), weight(M, 3).

% Avoid loss and spoil a future win from the other player
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), spoilWin(N, M, J), weight(M, 3).

% Avoid loss
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), weight(M, 3).

% Win the current grid
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), weight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), weight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), weight(M, 3).

% Play the best cell
nextMove(N, M, _) :- playableCell(N,M), weight(M, 1).
nextMove(N, M, _) :- playableCell(N,M), weight(M, 2).
nextMove(N, M, _) :- playableCell(N,M), weight(M, 3).


% bestMove(_,M,J) :- write('#1 N = '), write(N), write(' M = '), write(M), NextJ is 3 - J, not(vaGagner(M, _, NextJ)).
% bestMove(N,M,J) :- write('clause va gagner '), write(N), write(M), vaGagner(N, M, J), write('Le joueur actuel va gagner à '), write(N), write(M), !.

