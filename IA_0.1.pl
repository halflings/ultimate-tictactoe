:- asserta(weights([2,1,2,1,3,1,2,1,2])).

/*Miscellaneous functions*/
rand(X,L,H) :- random(Z), X is (truncate((H-L+1)*Z)+L).

/*AI functions*/
weight(I,X) :- getGridsState(State), nth1(I,State,S), (S=0 -> (weights(W), nth1(I,W,X)) ; X is 4).
cellValue(GridIndex, I, CellValue) :- gameField(D), nth1(GridIndex, D, G), nth1(I, G, CellValue).
playableCellsList(GridIndex,L) :- playableCellList1(GridIndex,L,1).
playableCellsList1(GridIndex,L,I) :- I < 10, cellValue(GridIndex,I,CellV), 
									I1 is I+1, (CellV = 0 -> playableCellsList1(GridIndex,[I|L],I1);
									playableCellsList1(GridIndex,L,I1)).

nextIAMove(N,M,J) :- nextIAMove1(N,M,J,1,1).
nextIAMove1(N,M,J,Igrid, Icell) :- getGridsState(State), allowedGrids(Al,State), /*on récupère les cases jouables dans Al*/
									Igrid < length(Al,X), /*condition d'arrêt du parcours de Al*/
									nth1(Igrid,Al,GridIndex), /*on récupère l'indice de la grille jouable*/
									playableCell(GridIndex,CellIndex), /*on récupère l'indice de la cellule jouable*/
									weight(CellIndex, W), /*on récupère le poids de la grille sur laquelle on envoie si cette cellule est jouée*/
									W = 1, not(winInOneMove(CellIndex,nextPlayer(NP),_)), N is GridIndex, M is CellIndex, J is NP,
									./*ON EST ICI, */