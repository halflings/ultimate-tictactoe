/*On retourne dans W l'état du champ. 0 si pas gagnée mais pas plein, 
1 si gagné par joueur 1, 2 si gagné par 2, 3 si plein et non gagné'
V est la liste des grilles gagnantes*/

winFieldInOneMove(N,W,V) :- fieldState(1,A1,_),fieldState(2,B2,_),fieldState(3,C3,_),fieldState(4,D4,_),
fieldState(5,E5,_),fieldState(6,F6,_),fieldState(7,G7,_),fieldState(8,H8,_), fieldState(9,I9,_), replace([A1,B2,C3,D4,E5,F6,G7,H8,I9], N, W, L),
nth1(1,L,A),nth1(2,L,B),nth1(3,L,C),nth1(4,L,D),nth1(5,L,E),nth1(6,L,F),nth1(7,L,G),nth1(8,L,H),nth1(9,L,I),won(A,B,C,D,E,F,G,H,I,V,W),!.
