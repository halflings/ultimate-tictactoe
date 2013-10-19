% On évite d'aller sur une grille qu'on va perdre
avoidLoss(_,M,J) :- NextJ is 3 - J, not(isWinningMove(M, _, NextJ)).
% On essaie de jouer une case pour gagner la grille actuelle
winGrid(N,M,J) :- isWinningMove(N, M, J).

nextMove(N, M, J) :- avoidLoss(N, M, J).
nextMove(N, M, J) :- winGrid(N, M, J).
% Si aucune des conditions précédentes n'est vérifiée, on prend une case quelconque.
nextMove(_, _, _).


% bestMove(_,M,J) :- write('#1 N = '), write(N), write(' M = '), write(M), NextJ is 3 - J, not(vaGagner(M, _, NextJ)).
% bestMove(N,M,J) :- write('clause va gagner '), write(N), write(M), vaGagner(N, M, J), write('Le joueur actuel va gagner à '), write(N), write(M), !.

