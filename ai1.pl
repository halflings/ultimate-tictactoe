% On évite d'aller sur une grille qu'on va perdre
avoidLoss(M,J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
% On essaie de jouer une case pour gagner la grille actuelle
winGrid(N,M,J) :- isWinningMove(N, M, J).

% Change this later (the same as "weights")
cellWeight(M, W) :- W is 3 - (2 - M mod 3) - (1 - M // 3).

% Avoid loss and win the current grid
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), cellWeight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), cellWeight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), winGrid(N, M, J), cellWeight(M, 3).

% Avoid loss
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), cellWeight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), cellWeight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), avoidLoss(M, J), cellWeight(M, 3).

% Win the current grid
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), cellWeight(M, 1).
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), cellWeight(M, 2).
nextMove(N, M, J) :- playableCell(N,M), winGrid(N, M, J), cellWeight(M, 3).


% Play the best cell
nextMove(N, M, _) :- playableCell(N,M), cellWeight(M, 1).
nextMove(N, M, _) :- playableCell(N,M), cellWeight(M, 2).
nextMove(N, M, _) :- playableCell(N,M), cellWeight(M, 3).


% bestMove(_,M,J) :- write('#1 N = '), write(N), write(' M = '), write(M), NextJ is 3 - J, not(vaGagner(M, _, NextJ)).
% bestMove(N,M,J) :- write('clause va gagner '), write(N), write(M), vaGagner(N, M, J), write('Le joueur actuel va gagner à '), write(N), write(M), !.

