s([0,0], "o").
s([1,0], "o").
s([2,0], "-").
s([0,1], "-").
s([1,1], "o").
s([2,1], "-").
s([0,2], "-").
s([1,2], "-").
s([2,2], "o").

o("1", [X,Y], [X1, Y]) :-   X1 is X+1.
o("2", [X,Y], [X1, Y1]) :-  X1 is X+1,
                            Y1 is Y+1.
o("3", [X,Y], [X, Y1]) :-   Y1 is Y+1.
o("4", [X,Y], [X1, Y1]) :-  X1 is X+1,
                            Y1 is Y-1.

% najde dvojice
najdi2([[S1, S2], [S2, S1]]) :- s(S1, "o"), o(_, S1, S2), s(S2, "o").

najdi(Y) :- findall(X, najdi2(X), Y), vypis(Y).

vypis([]).
% zase ty dvojice rozdělí a vypíše
vypis([[V1, V2]|R]) :- print(V1), nl, print(V2), nl, vypis(R).

%__________________________________
% použití : najdi(X)

% --
% S pozdravem a přáním hezkého dne,
% Bc. Daniel Makovský (MAK0065, 1. FEI N INF)
