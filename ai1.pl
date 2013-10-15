vaGagner(N, J) :- gameField(F), nth1(N,F,G), nth0(0,G,J),nth0(1,G,J),nth0(2,G,0), !.

nextMove(N,M,J) :- not(vaGagner(M, 3-J)), nextMove(N,M,J), !.
% TODO : Ajouter une condition au cas où tous les coups possibles font gagner l'autre joueur
nextMove(N,M,J) :- vaGagner(N, J).
nextMove(N,M,J).