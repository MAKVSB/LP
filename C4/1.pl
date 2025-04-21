nahrad(_,_,[], []) :- !.
nahrad(I, O, [I|XS], [O|Z]) :- !, nahrad(I,O,XS,Z).
nahrad(I, O, [X|XS], [X|Z]) :- nahrad(I,O,XS,Z).


h(a,b).
h(a,c).
h(a,d).
h(b,c).
h(b,d).
h(c,d).
h(c,e).
h(d,e).

h1(X,Y) :- h(X,Y).
h1(X,Y) :- h(Y,X).

vypis([]).
vypis([R1| R]) :- nl, write(R1), vypis(R).

rozdil([], _, []).
rozdil([A1|A],B,C) :- member(A1, B), rozdil(A, B, C).
rozdil([A1|A],B,[A1|C]) :- not(member(A1, B)), rozdil(A,B,C).

euler1(H, [], A, R) :- reverse([H|A],R).
euler1([X,Y], LH, A, R) :-
    member([Y,Z], LH),
    X \= Z,
    rozdil(LH, [[X,Y], [Y,X], [Y,Z], [Z,Y]], LH1),
    euler1([Y,Z], LH1, [[X,Y]|A], R).

euler(R) :- findall([X,Y], h1(X,Y), LH), member(H,LH), euler1(H, LH, [], R).

% poznámka
prefix(S,D1,L) :-
    atom_chars(S, C),
    append(D,_, C),
    length(D, L),
    atom_chars(D1, D).

odstran(N, SLOVO, SUFFIX) :-
    atom_chars(SLOVO, LS),
    append(X, S1, LS),
    length(X,N),
    atom_chars(SUFFIX, S1).

hledej(X,S,1) :- prefix(S, X, _).
hledej(X,S,P) :-
    odstran(1, S, S1),
    hledej(X, S1, P1),
    P is P1 + 1.

% okoli(S, HS, P, Z) :- hledej(HS,S,POZ), prefix(S, P, POZ), odstran()



d(1, a, 2).
d(1, b, 1).
d(2, a, 2).
d(2, b, 3).
d(3, a, 3).
d(3, b, 3).
ds(1).
df(3).


tra(Q, []) :- df(Q).
tra(Q, [H|T]) :- d(Q, H, Q1), tra(Q1, T).
dfa(W) :- atom_chars(W, LW), ds(Q), tra(Q, LW).

tra_v(Q, []) :-
    df(Q),
    nl,
    write(Q),
    write("=>").
tra_v(Q, [H|T]) :-
    nl,
    write(Q),
    write("=>"),
    atom_chars(S, [H|T]),
    write(S),
    d(Q, H, Q1),
    tra_v(Q1, T).
dfa_v(W) :- atom_chars(W, LW), ds(Q), tra_v(Q, LW).

cisla(X,X,[X]) :- !.
cisla(A,X,[A|R]) :- A<X, A1 is A+1, cisla(A1, X, R).

generuj1(_, []).
generuj1(X, [Y|LY]) :- assert(s([X,Y,-])), generuj1(X, LY).

generuj([], _).
generuj([X|LX], LY) :- generuj1(X, LY), generuj(LX, LY).

pole(MAXX, MAXY) :- cisla(0, MAXX, LX), cisla(0, MAXY, LY), generuj(LX,LY).

%:- dynamic s/1.
% assert(s([a,b,c])).
% retract(s(_)), fail.





