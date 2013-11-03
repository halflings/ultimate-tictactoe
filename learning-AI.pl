:- ['learning.pl'].


nextMove(N, M, J) :- avoidLostState(N, M, J),!.


avoidLostState(N, M, J) :- gameField(D) , playableCell(N, M), not(isLost(J,N,M,D)),!.
avoidLostState(N,M,_):- playableCell(N,M),!.
