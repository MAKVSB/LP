b(1).
b(2).
b(3).
b(4).

obarvi(A,B,C,D,E,F) :=
b(A),b(B),    A \= B,
b(C),         A \= C,
b(D),         A \= D,B \= D,C \= D,
b(E),         C \= E,D \= E,
b(F),         D \= F, E \= F.