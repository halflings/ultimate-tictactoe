vaGagner(N, 3, J) :- gameField(F), nth1(N,F,G), nth0(0,G,J),nth0(1,G,J),nth0(2,G,0),!.
vaGagner(N, 9, J) :- gameField(F), nth1(N,F,G), nth0(6,G,J),nth0(7,G,J),nth0(8,G,0),!.

nextMove(_,M,J) :- write('#1 N = '), write(N), write(' M = '), write(M), NextJ is 3 - J, not(vaGagner(M, _, NextJ)).
nextMove(N,M,J) :- write('clause va gagner '), write(N), write(M), vaGagner(N, M, J), write('Le joueur actuel va gagner à '), write(N), write(M), !.

% Si aucune des conditions précédentes n'est vérifiée, on prend une case quelconque.
% nextMove(_, _, _).