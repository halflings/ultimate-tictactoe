:- ['GrilleSolo.pl'].
:- ['Champ.pl'].
:- ['input.pl'].

/*Miscellaneous functions*/

/*Replaces element at index I (index starts at 1)*/
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replace(T, I1, X, R).
/*Returns a list containing the indexes of 0 within the list*/
zeroesPos(L1,L2) :- zeroesPos1(L1,1,[],L2).
zeroesPos1([],_,L,L).
zeroesPos1([H|T],I,L,X) :- H = 0,  I1 is I+1, zeroesPos1(T,I1,[I|L],X).
zeroesPos1([H|T],I,L,X) :- H \= 0, I1 is I+1, zeroesPos1(T,I1,L,X).
/*Print functions*/
printGameField :- gameField(D), print(D).
printLastMove :- lastMove(X,Y,Z), print(X), print(','), print(Y), print(', joueur '), print(Z).
printGridState :- gridsState(G), print(G).

/*****************/
/*INITIALIZATION*/
/*Game field*/

/*Grid state (0=normal, 1=won by player 1, 2=won by player 2, 3=full)*/
/*:- asserta(gridsState([0,0,0,0,0,0,0,0,0])).*/
/*:- asserta(lastMove(-1,-1,-1)).*/

/* IA functions */
playableGrid(N) :- getGridsState(State), allowedGrids(Al,State), nth0(0,Al,N).
/*Called with N, and I=1, to fill M*/
playableCell(N, M) :- playableGrid(N), gameField(D), nth1(N, D, G), nth1(M, G, 0).

/*****************/
/* MAIN FUNCTIONS*/

allowedGrids([M],State) :- lastMove(_,M,_), nth1(M,State,0). /*can play on normal grid*/
allowedGrids(L,State) :- lastMove(_,M,_), nth1(M,State,X), X > 0, zeroesPos(State,L). /*can play on normal grid*/
allowedGrids([1,2,3,4,5,6,7,8,9],_) :- lastMove(-1,-1,_). /*first time, one can play anywhere*/


nextPlayer(X) :- lastMove(_,_,-1), X is 1.
nextPlayer(X) :- lastMove(_,_,P), P > 0, X is 3-P.

getGridsState(X) :- etatGrilleChamp(1,X1,_),etatGrilleChamp(2,X2,_),etatGrilleChamp(3,X3,_),etatGrilleChamp(4,X4,_),etatGrilleChamp(5,X5,_),etatGrilleChamp(6,X6,_),etatGrilleChamp(7,X7,_),etatGrilleChamp(8,X8,_),etatGrilleChamp(9,X9,_), append([],[X1,X2,X3,X4,X5,X6,X7,X8,X9],X). /*a remplacer par la fonction de Champ quand elle marchera.*/

playMove(N,M,J) :- gameField(D), nth1(N,D,X), nth1(M,X,Y), Y \= 1, Y \= 2, /*checks that location not already played*/
					nextPlayer(J), /*check that the player is the good one */
					getGridsState(State), allowedGrids(Al,State), member(N,Al), /*checks that the grid is allowed*/
					replace(X,M,J,NewX),replace(D,N,NewX,NewD), retract(gameField(D)), assert(gameField(NewD)), /*updates grid*/
					lastMove(A,B,C), retract(lastMove(A,B,C)), asserta(lastMove(N,M,J)).  /*updates lastMove*/
					/*print('Le pro    in coup doit etre joue en '), allowedGrids(L), print(L), print(', par le joueur '), nextPlayer(NP), print(NP).*/ 


/********************/
/* EXECUTION BLOCK */

:- playableCell(N,M), nextPlayer(J), nextMove(N,M,J), !, playMove(N,M,J). /*the AI plays*/
:- gameField(Ch), getGridsState(X), allowedGrids(Al,X), print(Ch), print(' '), print(Al), print(' '), print(X). /*the result is sent*/
