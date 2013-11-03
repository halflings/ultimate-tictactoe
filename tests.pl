
:- ['main.pl'].


/* Tests Unitaires */


test1 :- write_ln('Test nextPlayer'),lastMove(_,_,J), N is 3 - J, nextPlayer(N), write('Test1 ok'), !.
test1 :- lastMove(_,_,-1), nextPlayer(J), write('Test2 ok'), !.
test1 :- write('Test échoué').

test2 :- write_ln('Test zeroesPos'),zeroesPos([0,0,1,6,0,1],[5,2,1]), write('Test1 ok').
test2 :- zeroesPos([1,2],[]), write('Test2 ok'),!.
test2 :- write('Test échoué').

test3 :- write_ln('Test allowedGrids'),L = [0,0,0,0,0,1,1,2,0],lastMove(_,M,_), M > -1,nth1(M,L,0), allowedGrids([M],L),  write('Test1 ok'), !.
test3 :- L = [0,0,0,0,0,1,1,2,0],lastMove(_,M,_), M > -1, nth1(M,L,P), P > 0 , zeroesPos(L,Z), allowedGrids(Z,L),write('Test2 ok'), !.
test3 :- L = [0,0,0,0,0,1,1,2,0],lastMove(_,M,_), allowedGrids([1,2,3,4,5,6,7,8,9],L), write('Test3 ok'), !.
test3 :- write('Test échoué').

test4(N,M) :- write_ln('Test cellWeight'), nextPlayer(J), cellWeight(N, M, J, W), write_ln(W), write('Test1 ok'), !.
test4(_,_) :- write('Test échoué').

test5 :- write_ln('Test biggerWeight'), nextPlayer(J), biggerWeight(J, W), write_ln(W), write('Test1 ok'), !.
test5 :- write('Test échoué').
