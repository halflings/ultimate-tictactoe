

:-asserta(vecteurgridStates([0,0,0,0,0,0,0,0,0])).

/*<full> check is the grid is not full,W is equal to 3 if it is full, 0 if not*/
full([],W) :- W = 3.
full([C|G],W) :- C \== 0, full(G,W).

%%Here, we expose the winning possibilities for a grid
won(A,A,A,_,_,_,_,_,_,[1,2,3],A):- A\==0,!.
won(_,_,_,A,A,A,_,_,_,[4,5,6],A):- A\==0,!.
won(_,_,_,_,_,_,A,A,A,[7,8,9],A):- A\==0,!.
won(A,_,_,A,_,_,A,_,_,[1,4,7],A):- A\==0,!.
won(_,A,_,_,A,_,_,A,_,[2,5,8],A):- A\==0,!.
won(_,_,A,_,_,A,_,_,A,[3,6,9],A):- A\==0,!.
won(A,_,_,_,A,_,_,_,A,[1,5,9],A):- A\==0,!.
won(_,_,A,_,A,_,A,_,_,[3,5,7],A):- A\==0,!.  % Si on a pas trouvé de combi gagnante, on regarde si elle est full
won(A,B,C,D,E,F,G,H,I,[],W):-full([A,B,C,D,E,F,G,H,I],W),!. % si elle n'est pas full, on a l'etat 0
won(_,_,_,_,_,_,_,_,_,[],0) :- !.


/*W is the state of the grid N. 0 if it is not full and not won, 
1 if won by player 1, 2 by player 2, 3 if full but not won
V is the list of the winning cases*/

gridState(G,W,V):- nth0(0,G,A1),nth0(1,G,B2),nth0(2,G,C3),nth0(3,G,D4),nth0(4,G,E5),nth0(5,G,F6),nth0(6,G,G7),nth0(7,G,H8),nth0(8,G,I9),
won(A1,B2,C3,D4,E5,F6,G7,H8,I9,V,W),!.  %;full(G,W),W==3,!)

%Gives the state of the grid N in the gameField'
fieldState(N,W,V):-gameField(D), nth0(N,D,G), gridState(G,W,V),!.

/*if gagne(A,B,C), W est la liste des cases gagnées*/



%isWinning(J,1,2,3,4,5,6,7,8,9,R). %J is the player, 1,2....9 are the values of the cases of the grid we want to study, R is the number
%of the case the player J has to play to win the grid
isWinning(A,A,A,0,_,_,_,_,_,_,3):-A\==0.
isWinning(A,A,0,A,_,_,_,_,_,_,2):-A\==0.
isWinning(A,0,A,A,_,_,_,_,_,_,1):-A\==0.


isWinning(A,_,_,_,A,A,0,_,_,_,6):-A\==0.
isWinning(A,_,_,_,A,0,A,_,_,_,5):-A\==0.
isWinning(A,_,_,_,0,A,A,_,_,_,4):-A\==0.

isWinning(A,_,_,_,_,_,_,A,A,0,9):-A\==0.
isWinning(A,_,_,_,_,_,_,A,0,A,8):-A\==0.
isWinning(A,_,_,_,_,_,_,0,A,A,7):-A\==0.

isWinning(A,A,_,_,0,_,_,A,_,_,4):-A\==0.
isWinning(A,A,_,_,A,_,_,0,_,_,7):-A\==0.
isWinning(A,0,_,_,A,_,_,A,_,_,1):-A\==0.


%isWinning(_,A,_,_,A,_,_,A,_,[2,5,8],A):- A\==0,!.
isWinning(A,_,A,_,_,0,_,_,A,_,5):-A\==0.
isWinning(A,_,A,_,_,A,_,_,0,_,8):-A\==0.
isWinning(A,_,0,_,_,A,_,_,A,_,2):-A\==0.


%isWinning(_,_,A,_,_,A,_,_,A,[3,6,9],A):- A\==0,!.
isWinning(A,_,_,A,_,_,0,_,_,A,6):-A\==0.
isWinning(A,_,_,A,_,_,A,_,_,0,9):-A\==0.
isWinning(A,_,_,0,_,_,A,_,_,A,3):-A\==0.

%isWinning(A,_,_,_,A,_,_,_,A,[1,5,9],A):- A\==0,!.
isWinning(A,A,_,_,_,0,_,_,_,A,5):-A\==0.
isWinning(A,A,_,_,_,A,_,_,_,0,9):-A\==0.
isWinning(A,0,_,_,_,A,_,_,_,A,1):-A\==0.


%isWinning(_,_,A,_,A,_,A,_,_,[3,5,7],A):- A\==0,!. 
isWinning(A,_,_,A,_,0,_,A,_,_,5):-A\==0.
isWinning(A,_,_,0,_,A,_,A,_,_,3):-A\==0.
isWinning(A,_,_,A,_,A,_,0,_,_,7):-A\==0, !.

%N is the number of the grid, J the player, I the list of winning moves. Empty if the grid is not one-move winning.
winInOneMove(N,J,I) :- gameField(D),N2 is N-1, nth0(N2,D,G),nth0(0,G,A1),nth0(1,G,B2),nth0(2,G,C3),
nth0(3,G,D4),nth0(4,G,E5),nth0(5,G,F6),nth0(6,G,G7),nth0(7,G,H8),nth0(8,G,I9),
findall(I,isWinning(J,A1,B2,C3,D4,E5,F6,G7,H8,I9,I),I),I\==[],!.


membre(X,[X|_]).
membre(X,[_|L]) :- membre(X,L).

%isWinningMove tells if the move in the grid N and case C for player J makes him win. True or false.
isWinningMove(N,C,J):-winInOneMove(N,J,G), membre(C,G),!.
