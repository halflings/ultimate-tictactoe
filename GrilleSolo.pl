/*Miscellaneous functions*/
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replace(T, I1, X, R).
imprimerGrille :- champJeu(D), print(D).
imprimerDC :- dernierCoup(X,Y), print(X), print(','), print(Y).

/*Initialization*/
:- asserta(champJeu([[1,0,2,0,0,0,0,0,0],[1,4,5,4,0,2,6,7,1],[0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1]])).

/*First one checks if one can play in (N,M), then if possible it's done*/
/*Do not check if the player is supposed to play in this grid (depends on dernierCoup))*/
jouerCoup(N,M,J) :- champJeu(D), nth0(N,D,X), nth0(M,X,Y), Y \= 1, Y \= 2, /*check that not already played*/
					replace(X,M,J,NewX),replace(D,N,NewX,NewD), retract(champJeu(D)), assert(champJeu(NewD)), /*updates grid*/
					asserta(dernierCoup(N,M)).


%On retourne dans W l'état de la grille N. 0 si pas gagnée mais pas pleine, 
%1 si gagnée par joueur 1, 2 si gagnée par 2, 3 si pleine et non gagnée'
%V est la liste des cases gagnantes

etatGrille(N,W,V):- champJeu(D), nth0(N,D,G),nth0(0,G,A1),nth0(1,G,B2),nth0(2,G,C3),nth0(3,G,D4),nth0(4,G,E5),nth0(5,G,F6),nth0(6,G,G7),nth0(7,G,H8),nth0(8,G,I9),
gagnee(A1,B2,C3,D4,E5,F6,G7,H8,I9,V,W),!.  %;pleine(G,W),W==3,!)

pleine([],W) :- W = 3.
pleine([C|G],W) :- C \== 0, pleine(G,W).

%on aura notre base de faits, et on vérifie si il y a un truc gagnée
gagnee(A,A,A,_,_,_,_,_,_,[1,2,3],A):- A\==0,!.
gagnee(_,_,_,A,A,A,_,_,_,[4,5,6],A):- A\==0,!.
gagnee(_,_,_,_,_,_,A,A,A,[7,8,9],A):- A\==0,!.
gagnee(A,_,_,A,_,_,A,_,_,[1,4,7],A):- A\==0,!.
gagnee(_,A,_,_,A,_,_,A,_,[2,5,8],A):- A\==0,!.
gagnee(_,_,A,_,_,A,_,_,A,[3,6,9],A):- A\==0,!.
gagnee(A,_,_,_,A,_,_,_,A,[1,5,9],A):- A\==0,!.
gagnee(_,_,A,_,A,_,A,_,_,[3,5,7],A):- A\==0,!.  % Si on a pas trouvé de combi gagnante, on regarde si elle est pleine
gagnee(A,B,C,D,E,F,G,H,I,[],W):-pleine([A,B,C,D,E,F,G,H,I],W),!. % si elle n'est pas pleine, on a l'etat 0
gagnee(_,_,_,_,_,_,_,_,_,[],0) :- !.


%SI gagne(A,B,C), W est la liste des cases gagnées


vaGagner(N,I). %I est le nombre de coup restants avant de gagner, N le numéro de la grille

:-asserta(vecteurEtatGrilles([0,0,0,0,0,0,0,0,0])).
