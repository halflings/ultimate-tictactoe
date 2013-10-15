:- asserta(Weights([2,1,2,1,3,1,2,1,2])).

weight(I,X) :- Weights(W), nth1(I,W,X).



rand(X,L,H) :- random(Z), X is (truncate((H-L+1)*Z)+L).



/************* À intégrer dans GrilleSolo ************/



/*****************************************************/