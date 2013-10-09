/*Miscellaneous functions*/
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replace(T, I1, X, R).
imprimerGrille :- champJeu(D), print(D).
imprimerDC :- dernierCoup(X,Y), print(X), print(','), print(Y).

/*Initialization*/
:- asserta(champJeu([[1,0,2,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1]])).

/*First one checks if one can play in (N,M), then if possible it's done*/
/*Do not check if the player is supposed to play in this grid (depends on dernierCoup))*/
jouerCoup(N,M,J) :- champJeu(D), nth0(N,D,X), nth0(M,X,Y), Y \= 1, Y \= 2, /*check that not already played*/
					replace(X,M,J,NewX),replace(D,N,NewX,NewD), retract(champJeu(D)), assert(champJeu(NewD)), /*updates grid*/
					asserta(dernierCoup(N,M)).

