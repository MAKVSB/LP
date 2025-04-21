b(a,b,1).
b(b,d,2).
b(d,e,3).
b(a,c,2).
b(c,e,3).

b(c,b,1).
b(b,a,1).

cesta(A,C) :- b(A,C).
cesta(A,C) :- b(A,B), cesta(B,C).

cesta(A,C,S) :- b(A,C,S).
cesta(A,C,S) :- b(A,B,S1), cesta(B,C,S2), S is S1 + S2.


cesta(A,C,S,[]) :- b(A,C,S).
cesta(A,C,S,[B|Z]) :- b(A,B,S1), cesta(B,C,S2,Z), S is S1 + S2.

vypis([]).
vypis([R1| R]) :- nl, write(R1), vypis(R).

/* findall([X,Y,Z], cesta(a, X, Y, Z), R), vypis(R).*/

c(X,Y,P) :- c1(X,Y,[], P1), reverse(P, P1).
c1(X,Z,P,P) :- b(X,Z,_).
c1(X,Z,A,P) :- b(X,Y,_), not(member(Y, A)), c1(Y,Z, [Y|A], P).

s([0,0]).
s([0,1]).
s([0,2]).
s([1,0]).
s([1,1]).
s([1,2]).
s([2,0]).
s([2,1]).
s([2,2]).

move([X,Y], [X1, Y1]) :- (X1 is X+2;X1 is X-2), (Y1 is Y+1; Y1 is Y-1), s([X1, Y1]).
move([X,Y], [X1, Y1]) :- (X1 is X+1;X1 is X-1), (Y1 is Y+2; Y1 is Y-2), s([X1, Y1]).

kun([X,Y], [X1, Y1]) :- s([X,Y]), move([X,Y],[X1,Y1]).

/*
 * x
 * x
 * X
 */
o(1, [X,Y], [X, Y1], [X,Y2]) :- Y1 is Y+1, Y2 is Y+2.
/*
 * Xxx
 */
o(2, [X,Y], [X1,Y], [X2, Y]) :- X1 is X+1, X2 is X+2.
/*
 * x
 * Xx
 */
o(3, [X,Y], [X1,Y], [X,Y1]) :- X1 is X+1, Y1 is Y+1.
/*
 * Xx
 *  x
 */
o(4, [X,Y], [X1,Y], [X1,Y1]) :- X1 is X+1, Y1 is Y-1.
/*
 *  x
 * Xx
 */
o(5, [X,Y], [X1,Y], [X1,Y1]) :- X1 is X+1, Y1 is Y+1.
/*
 * xx
 * X
 */
o(6, [X,Y], [X,Y1], [X1,Y1]) :- X1 is X+1, Y1 is Y+1.


tetris(RS) :- findall([X,Y], s([X,Y]), S), tetris1(S, R), sort(R, RS).

rozdil([], _, []).
rozdil([A1|A],B,C) :- member(A1, B), rozdil(A, B, C).
rozdil([A1|A],B,[A1|C]) :- not(member(A1, B)), rozdil(A,B,C).

tetris1([], []).
tetris1(S, [[ID, S1, S2, S3]|R]) :- member(S1,S), o(ID, S1, S2, S3),
                                    member(S2, S), member(S3,S),
                                    rozdil(S, [S1, S2, S3], SNEW), tetris1(SNEW, R).




