:- ['GrilleSolo.pl'].
:- ['Champ.pl'].
:- ['input.pl'].
:- ['learning.pl'].

:- asserta(stateQueue(2,2,3,[a,b])).
/*Miscellaneous functions*/

/*Replaces element at index I (index starts at 1)*/
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > 0, I1 is I-1, replace(T, I1, X, R).
/*Returns a list containing the indexes of 0 within the list*/
zeroesPos(L1,L2) :- zeroesPos1(L1,1,[],L2).
zeroesPos1([],_,L,L).
zeroesPos1([H|T],I,L,X) :- H = 0,  I1 is I+1, zeroesPos1(T,I1,[I|L],X).
zeroesPos1([H|T],I,L,X) :- H \= 0, I1 is I+1, zeroesPos1(T,I1,L,X).
/*Print function*/
printTotalState :- gameField(Ch), getGridsState(X), allowedGrids(Allowed,X), Last = [N, M, J], lastMove(N, M, J),
   print(Ch), print(' '), print(Allowed), print(' '), print(X), print(' '), print(Last). 

/*****************/
/* MAIN FUNCTIONS*/

/* Normal case: play on the grid at the last cell's position */
allowedGrids([M],State) :- lastMove(_,M,_), nth1(M, State, 0). 
/* If the grid on the last cell's position have already be won, play on any valid grid */
allowedGrids(L,State) :- lastMove(_,M,_), nth1(M, State, X), X > 0, zeroesPos(State, L).
/* Default initialization value: one can play anywhere */
allowedGrids([1,2,3,4,5,6,7,8,9],_) :- lastMove(-1,-1,_). 

/* Returns the state of all grids as a list. For instance: [0, 1, 2, 0, 0, 2, 1, 0, 0]*/
getGridsState([X1,X2,X3,X4,X5,X6,X7,X8,X9]) :- fieldState(1,X1,_),fieldState(2,X2,_),fieldState(3,X3,_),fieldState(4,X4,_),fieldState(5,X5,_),fieldState(6,X6,_),fieldState(7,X7,_),fieldState(8,X8,_),fieldState(9,X9,_).

/* Functions to make dealing with playable cells/grids easier */
playableGrid(N) :- getGridsState(State), allowedGrids(Allowed,State), member(N, Allowed).
playableCell(N, M) :- playableGrid(N), gameField(D), nth1(N, D, G), nth1(M, G, 0).

nextPlayer(X) :- lastMove(_,_,-1), X is 1.
nextPlayer(X) :- lastMove(_,_,P), P > 0, X is 3-P.


playMove(N,M,J) :- gameField(D), nth1(N,D,G), nth1(M,G,0), /*checks that location not already played*/
					nextPlayer(J), /*check that the player is the good one */
					getGridsState(State), allowedGrids(Al,State), member(N,Al), /*checks that the grid is allowed*/
					replace(G,M,J,NewG),replace(D,N,NewG,NewD), retract(gameField(D)), assert(gameField(NewD)), /*updates grid*/
					lastMove(A,B,C), retract(lastMove(A,B,C)), asserta(lastMove(N,M,J)).  /*updates lastMove*/



%register
%isLost(J,C,G,GF).
symetricGrid([],[]).
symetricGrid([0|Q],[0|Q2]):-symetricGrid(Q,Q2),!.
symetricGrid([T|Q],[T2|Q2]):- T2 is 3-T,T is 3-T2, symetricGrid(Q,Q2),!.

symetricField([X1,X2,X3,X4,X5,X6,X7,X8,X9], [XS1,XS2,XS3,XS4,XS5,XS6,XS7,XS8,XS9]):-symetricGrid(X1,XS1),symetricGrid(X2,XS2),symetricGrid(X3,XS3),symetricGrid(X4,XS4),symetricGrid(X5,XS5),
												symetricGrid(X6,XS6),symetricGrid(X7,XS7),symetricGrid(X8,XS8),symetricGrid(X9,XS9),!.


ended(J,[X1,X2,X3,X4,X5,X6,X7,X8,X9]):- stateQueue(JF,NF,MF,GF), !,%Load or saved State, and check if we are not the player who has possibly won.
									won(X1,X2,X3,X4,X5,X6,X7,X8,X9,X,J),!, X\==[], % We check if th eplayer J has won.

									not(isLost(JF,NF,MF,GF)), %We check if we have already learned this. If not, we continue
											open('../learning.pl',append,Stream),%We open the file 'learning.pl' with append parameter ( add strings after existing strings in file)
											write(Stream,'isLost('),write(Stream,JF),write(Stream,','),write(Stream,NF), 
											write(Stream,','), write(Stream,MF), write(Stream,','), write(Stream,GF),
											write(Stream,').'),nl(Stream), % we write our first 'isLost(JF,NF,MF,GF).''
											JFS is 3- JF, symetricField(GF,GFS),%We calculate the symetric configuration.
												write(Stream,'isLost('),write(Stream,JFS),write(Stream,','),write(Stream,NF), 	write(Stream,','), write(Stream,MF), 
											write(Stream,','), write(Stream,GFS),write(Stream,').'),nl(Stream),%We write the symetric configuration
											close(Stream),['learning.pl']. %Close the stream, and reload learning.pl to be aware of the new clauses.


/********************/
/* EXECUTION BLOCK */

/* The AI plays its move*/
:- nextPlayer(J), nextMove(N,M,J),lastMove(NLM,MLM,JLM),(NLM \== -1,stateQueue(JF,NF,MF,GF), 
					retract(stateQueue(JF,NF,MF,GF)), gameField(G),nth1(NLM,G,R1), replace(R1,MLM,0,XNew), replace(G,NLM,XNew,GFinal),
					asserta(stateQueue(JLM,NLM,MLM,GFinal)), !, playMove(N,M,J) ; ! ,playMove(N,M,J)).%, write(D).  gameField(D),
/* Prints the result on screen: "gamefield[space]allowed_grids[space]grids_state[space]last_move" */
 :- getGridsState(Ch), lastMove(_,_,J), (ended(J,Ch);J==J).
 :- printTotalState.