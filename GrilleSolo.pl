/*pleine vérifie que la grille ne soit pas pleine, et renvoit 3 si elle l'est, 0 sinon*/
pleine([],W) :- W = 3.
pleine([C|G],W) :- C \== 0, pleine(G,W).

%on aura notre base de faits, et on vérifie si il y a un truc gagné
gagnee(A,A,A,_,_,_,_,_,_,[1,2,3],A):- A\==0,!.
gagnee(_,_,_,A,A,A,_,_,_,[4,5,6],A):- A\==0,!.
gagnee(_,_,_,_,_,_,A,A,A,[7,8,9],A):- A\==0,!.
gagnee(A,_,_,A,_,_,A,_,_,[1,4,7],A):- A\==0,!.
gagnee(_,A,_,_,A,_,_,A,_,[2,5,8],A):- A\==0,!.
gagnee(_,_,A,_,_,A,_,_,A,[3,6,9],A):- A\==0,!.
gagnee(A,_,_,_,A,_,_,_,A,[1,5,9],A):- A\==0,!.
gagnee(_,_,A,_,A,_,A,_,_,[3,5,7],A):- A\==0,!.  % Si on n'a pas trouvé de combi gagnante, on regarde si elle est pleine
gagnee(A,B,C,D,E,F,G,H,I,[],W):-pleine([A,B,C,D,E,F,G,H,I],W),!. % si elle n'est pas pleine, on a l'etat 0
gagnee(_,_,_,_,_,_,_,_,_,[],0) :- !.

/*On retourne dans W l'état de la grille N. 0 si pas gagnée mais pas pleine, 
1 si gagnée par joueur 1, 2 si gagnée par 2, 3 si pleine et non gagnée'
V est la liste des cases gagnantes*/
/*Attention à l'indexation (commence à 0 ?).*/
etatGrille(G,W,V):- nth0(0,G,A1),nth0(1,G,B2),nth0(2,G,C3),nth0(3,G,D4),nth0(4,G,E5),nth0(5,G,F6),nth0(6,G,G7),nth0(7,G,H8),nth0(8,G,I9),
gagnee(A1,B2,C3,D4,E5,F6,G7,H8,I9,V,W),!.  %;pleine(G,W),W==3,!)

%Donne l'état de la grille numéro N dans le champJeu, selon la numérotation choisie (les numéros partent à 1).'
etatGrilleChamp(N,W,V):-champJeu(D), nth1(N,D,G), etatGrille(G,W,V),!.

/*SI gagne(A,B,C), W est la liste des cases gagnées*/



%vaGagner(N,J,I). %I est le nombre de coup restants avant de gagner, N le numéro de la grille, J le joueur à qui on s'interesse

%vaGagner(N,J,I) :- champJeu(D),nth0(N,D,G),
%:- 
