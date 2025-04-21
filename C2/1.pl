fib(1,0).
fib(2,1).
fib(N,F) :- N>2, N1 is N-1, N2 is N-2, fib(N1,F1), fib(N2,F2), F is F1 + F2.


gph(a, b).
gph(a, c).
gph(b, d).
gph(d, e).
gph(c, e).


cesta(A, C) :- gph(A,C).
cesta(A, C) :- gph(A,B), cesta(B,C).



prvek(X, [X|_]).
prvek(X, [_|Y]) :- prvek(X,Y).


len([], 0).
len([_|T], N) :- length(T, N1), N is N1+1.


sum([], 0).
sum([H|T], N) :- sum(T, N1), N is N1+H.

# výber sudých čísel
vyber_s([], []).
vyber_s([H| T1], [H| T2]) :- 0 is H mod 2, vyber_s(T1, T2).
vyber_s([H| T1], X) :- 1 is H mod 2, vyber_s(T1, X).

# výběr na lichých pozicích
vyber_l([], []).
vyber_l([H1], [H1]).
vyber_l([H1, _ |T1], [H1 | T2]) :- vyber_l(T1, T2).

join([], [], []).
join([], L2, L2).
join([H1 | L1], L2, [H1 | L3]) :- join(L1, L2, L3).

spol(L1, [], L1).
spol([], _, []).
spol([H1|L1], L2, [H1|L3]) :- prvek(H1, L2), spol(L1, L2, L3).
spol([H1|L1], L2, L3) :- not(prvek(H1, L2)), spol(L1, L2, L3).
