:- ['GrilleSolo'].

/*On retourne dans W l'état du champ. 0 si pas gagnée mais pas plein, 
1 si gagné par joueur 1, 2 si gagné par 2, 3 si plein et non gagné'
V est la liste des grilles gagnantes*/

etatChamp(W,V) :- etatGrilleChamp(0,A1,_),etatGrilleChamp(1,B2,_),etatGrilleChamp(2,C3,_),etatGrilleChamp(3,D4,_),
etatGrilleChamp(4,E5,_),etatGrilleChamp(5,F6,_),etatGrilleChamp(6,G7,_),etatGrilleChamp(7,H8,_), etatGrilleChamp(8,I9,_),
gagnee(A1,B2,C3,D4,E5,F6,G7,H8,I9,V,W),!.
