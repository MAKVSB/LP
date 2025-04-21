c(0).
c(1).
c(2).
c(3).
c(4).
c(5).
c(6).
c(7).
c(8).
c(9).
c(10).
c(11).
c(12).

vypocti(A,B,C,D,E,F,G,H,I) :-
c(A),c(B),c(C), 6 is A*B*C,
c(D),c(E),c(F), 6 is D+E+F,
c(G),c(H),c(I), 6 is G+H+I,
4 is A+D+G,
4 is B-E+H,
4 is C+F-I.
