% Logical programming, Summer 2025,  Daniel Makovský
% Play with "tah(<X>, <Y>)." The computer plays automatically
% Computer starts by running "tp."
% If you want to simulate computer move for debugging, you can use "tah_a([<X>, <Y>])." But dont forget to disable automatic computer moves
% You can reset the playground by running "rs."

:- dynamic ss/2.
:- dynamic is_empty_flag/1.
:- dynamic krok/3.
:- dynamic game/3.

cisla(X,X,[X]) :- !.
cisla(A,X,[A|R]) :- A<X, A1 is A+1, cisla(A1, X, R).

reset :- retractall(ss(_,_)), retractall(krok(_,_, _)).
start :- c_pole, v_pole.
rs :- reset, start.

% vypis
v_radek(Y) :-   findall([X,H], ss([X,Y],H), LXH),
                sort(LXH, SLXH),
                write(Y),
                write(' | '),
                r_vypis(SLXH).

v_pole :- cisla(0, 9, LY),
                sort(LY, SLY),
                reverse(SLY, RLY),
                v_pole1(RLY),
                v_radek_label,
                !.

v_pole1([]) :- !.
v_pole1([Y|LY]) :-  v_radek(Y),
                    nl,
                    v_radek_empty,
                    nl,
                    v_pole1(LY).

r_vypis([]).
r_vypis([[_,H]|L]) :-   write(H),
    write(' | '),
    r_vypis(L).

v_radek_empty_part(0).
v_radek_empty_part(A) :-    write('----'),
                            A1 is A-1,
                            v_radek_empty_part(A1).
v_radek_empty :-    write('  '),
                    V is 9+1,
                    v_radek_empty_part(V),
                    write('- ').

v_radek_label_part(X, X).
v_radek_label_part(X, Y) :-  write(X), write('   '), X1 is X+1, v_radek_label_part(X1, Y).
v_radek_label :- write('    '), v_radek_label_part(0, 10).

% objekty
o(2, [X,Y], [X, Y1], [X, Y2], [X,Y3], [X,Y4]) :- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.
o(1, [X,Y], [X1, Y], [X2, Y], [X3,Y], [X4,Y]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4.
o(4, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y-1, Y2 is Y-2, Y3 is Y-3, Y4 is Y-4.
o(3, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.

% Objekty - 5 polí pro detekci od středu
o3(1, [X,Y], [X1, Y], [X2, Y], [X3,Y], [X4,Y]) :- X is X2-2, X1 is X2-1, X3 is X2+1, X4 is X2+2.
o3(4, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :-X is X2-2, X1 is X2-1, X3 is X2+1, X4 is X2+2,
    Y is Y2+2, Y1 is Y2+1, Y3 is Y2-1, Y4 is Y2-2.
o3(2, [X,Y], [X, Y1], [X, Y2], [X,Y3], [X,Y4]) :- Y is Y2-2, Y1 is Y2-1, Y3 is Y2+1, Y4 is Y2+2.
o3(3, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :-X is X2-2, X1 is X2-1, X3 is X2+1, X4 is X2+2,
                                                        Y is Y2-2, Y1 is Y2-1, Y3 is Y2+1, Y4 is Y2+2.
% Objekty - 6 polí pro snažší kontrolu okolí
o6(3, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4], [X5, Y5]) :-  X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4, X5 is X+5,
                                                                    Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4, Y5 is Y+5.
o6(1, [X, Y], [X1, Y], [X2, Y], [X3, Y], [X4, Y], [X5, Y]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4, X5 is X+5.
o6(2, [X, Y], [X, Y1], [X, Y2], [X, Y3], [X, Y4], [X, Y5]) :- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4, Y5 is Y+5.

o6(4, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4], [X5, Y5]) :-  X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4, X5 is X+5,
                                                                    Y1 is Y-1, Y2 is Y-2, Y3 is Y-3, Y4 is Y-4, Y5 is Y-5.
% Negated coord check
ssn(X, ' ') :- (ss(X, 'x') ; ss(X, 'o')).
ssn(X, 'o') :- (ss(X, 'x') ; ss(X, ' ')).
ssn(X, 'x') :- (ss(X, ' ') ; ss(X, 'o')).

% tah hráče o
tah(X,Y) :- ss([X,Y],' '), retract(ss([X,Y],' ')), assert(ss([X,Y], 'o')), nl, v_pole, map(MAP), assert(krok([X,Y],'o',MAP)),test_v(o), nl, tp.

% test vítězství. H = symbol hráče (o/x)
test_v(H) :-    ss(S1,H), o(_,S1,S2,S3,S4,S5),
                ss(S2, H), ss(S3, H), ss(S4, H), ss(S5, H),
                nl, write('Vítěz: '), write(H), write(' : '), write([S1, S2, S3, S4, S5]), eviduj_hru(H).
test_v(_).

% ukládání hry
map(X) :- findall([S, H], ss(S, H), LX), sort(LX, X).
round(S,H) :- map(MAP), assert(krok(S,H,MAP)).
uloz([]).
uloz([[S,P]|LP]) :- game(S, N, P), N1 is N+1, retract(game(S,N,P)), assert(game(S,N1,P)), uloz(LP).
uloz([[S,P]|LP]) :- not(game(S, _, P)), assert(game(S,1,P)), uloz(LP).
eviduj_hru('x') :- findall([S, POLE], krok(S,'x',POLE), LK), uloz(LK).
eviduj_hru('o') :- findall([S, POLE], krok(S,'o',POLE), LK), nahrad(LK, LK1), uloz(LK1).

nahrad([], []).
nahrad([[S, P]|LK], [[S,P1]|LKNEW]) :- nahrad2(P, P1), nahrad(LK, LKNEW).

nahrad2([],[]).
nahrad2([[S, 'o']|IR],[[S,'x']|OR]) :- nahrad2(IR, OR).
nahrad2([[S, 'x']|IR],[[S,'o']|OR]) :- nahrad2(IR, OR).
nahrad2([[S, ' ']|IR],[[S,' ']|OR]) :- nahrad2(IR, OR).

tah_a([X,Y]) :- retract(ss([X,Y],' ')), assert(ss([X,Y], 'x')), v_pole, nl, write('Tah :['), write(X), write(','), write(Y), write(']'), map(MAP), assert(krok([X,Y],'x',MAP)), test_v(x).
tah_a([X,Y], RULE, O) :- retract(ss([X,Y],' ')), assert(ss([X,Y], 'x')), v_pole, nl, write('Tah '), write(RULE), write(' '), write(O), write(': ['), write(X), write(','), write(Y), write(']'), map(MAP), assert(krok([X,Y],'x',MAP)), test_v(x).

% pomocné metody
% vypočítání forku
vypocitej_fork([S1X, S1Y], [S5X, S5Y], [S6X, S6Y], [SAX, SAY]) :-
    (S1X = S5X ; S1Y = S5Y),  % Ensure they are in a line (horizontal or vertical)
    (
        (S1X = S6X, (S6Y is S1Y - 2 ; S6Y is S1Y + 2)) ;
        (S1Y = S6Y, (S6X is S1X - 2 ; S6X is S1X + 2))
    ),
    (
        (S5X = SAX, (SAY is S5Y - 2 ; SAY is S5Y + 2)) ;
        (S5Y = SAY, (SAX is S5X - 2 ; SAX is S5X + 2))
    ).

% pravidla ZDE
%_________________________________________________________________________________________

% UTOK: doplnění 4 -> 5
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'O_DOP_1', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S2, 'O_DOP_2', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S3, 'O_DOP_3', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'O_DOP_4', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'O_DOP_5', O).

% obrana: vyblokování 4 -> 5
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), tah_a(S1, 'D_DOP_WIN_1', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), tah_a(S2, 'D_DOP_WIN_2', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ss(S5, 'o'), tah_a(S3, 'D_DOP_WIN_3', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ss(S5, 'o'), tah_a(S4, 'D_DOP_WIN_4', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, ' '), tah_a(S5, 'D_DOP_WIN_5', O).

% Defense do 4 trochu chytřejší
% oponent není debil a umí blokovat trojice/čtveřice - tedy čtveřici je třeba tvořit pouze pokud je trojice volná z obou stran.
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), ss(S6, ' '), tah_a(S2, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ss(S5, 'o'), ss(S6, ' '), tah_a(S3, 'D_DOP_4B_2', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ss(S5, 'o'), ss(S6, ' '), tah_a(S4, 'D_DOP_4B_3', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, ' '), ss(S6, ' '), tah_a(S5, 'D_DOP_4B_4', O).

% Útok doplnění 3 -> 4 s ochranou okolí
% oponent není debil a umí blokovat trojice/čtveřice - tedy čtveřici je třeba tvořit pouze pokud je trojice volná z obou stran.
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), ss(S6, ' '), tah_a(S2, 'O_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), ss(S6, ' '), tah_a(S3, 'O_DOP_4B_2', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, 'x'), ss(S6, ' '), tah_a(S4, 'O_DOP_4B_3', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), ss(S6, ' '), tah_a(S5, 'O_DOP_4B_4', O).

% Offense - zákeřný kříž
% nahoru

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    ss(S3, 'x'),
    (ss(S2, 'x') ; ss(S5, 'x')),

    % dokud to není vyloženě zablokované tak prioritizovat
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'), ssn(SZ, 'o'),

    (
        (
            ss(S6, _),
            o6(_, S6, S7, S8, S9, S4, SA),
            S9 \= S3,

            ss(S9, ' '),
            ss(S7, 'x'), ss(S8, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S6, 'x') ; ssn(SA, 'x'))
        ) ; (
            ss(S7, _),
            o6(_, S7, S8, S9, S4, SA, SB),
            S9 \= S3,

            ss(S9, ' '),
            ss(S8, 'x'), ss(SA, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S7, 'x') ; ssn(SB, 'x'))
        ) ; (
            ss(S8, _),
            o6(_, S8, S9, S4, SA, SB, SC),
            S9 \= S3,

            ss(SA, ' '),
            ss(SB, 'x'), ss(S9, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S8, 'x') ; ssn(SC, 'x'))
        ) ; (
            ss(S9, _),
            o6(_, S9, S4, SA, SB, SC, SD),
            S9 \= S3,

            ss(SA, ' '),
            ss(SB, 'x'), ss(SC, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S9, 'x') ; ssn(SD, 'x'))
        )
    ),

    tah_a(S4, 'O_CROSSX_UP', O).


% Offense - zákeřný kříž
% dolu

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    ss(S4, 'x'),
    (ss(S2, 'x') ; ss(S5, 'x')),

    % dokud to není vyloženě zablokované tak prioritizovat
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    (
        (
            ss(S6, _),
            o6(_, S6, S7, S8, S9, S3, SA),
            S9 \= S2,

            ss(S9, ' '),
            (ss(S7, 'x'), ss(S8, 'x')),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S6, 'x') ; ssn(SA, 'x'))
        ) ; (
            ss(S7, _),
            o6(_, S7, S8, S9, S3, SA, SB),
            S9 \= S2,

            ss(S9, ' '),
            (ss(S8, 'x'), ss(SA, 'x')),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S7, 'x') ; ssn(SB, 'x'))
        ) ; (
            ss(S9, _),
            o6(_, S9, S3, SA, SB, SC, SD),
            S9 \= S2,

            ss(SA, ' '),
            ss(SB, 'x'), ss(SC, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S9, 'x') ; ssn(SD, 'x'))
        ) ; (
            ss(S8, _),
            o6(_, S8, S9, S3, SA, SB, SC),
            S9 \= S2,

            ss(SA, ' '),
            ss(SB, 'x'), ss(S9, 'x'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S8, 'x') ; ssn(SC, 'x'))
        )
    ),

    tah_a(S3, 'O_CROSSX_DOWN', O).

% Deffence - zákeřný kříž
% dolu

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    ss(S4, 'o'),
    (ss(S2, 'o') ; ss(S5, 'o')),

    ssn(S2, 'x'), ssn(S3, 'x'), ssn(S4, 'x'), ssn(S5, 'x'),

    (
        (
            ss(S6, _),
            o6(_, S6, S7, S8, S9, S3, SA),
            S9 \= S2,

            ss(S9, ' '),
            (ss(S7, 'o'), ss(S8, 'o')),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S6, 'x') ; ssn(SA, 'x'))
        ) ; (
            ss(S7, _),
            o6(_, S7, S8, S9, S3, SA, SB),
            S9 \= S2,

            ss(S9, ' '),
            ss(S8, 'o'), ss(SA, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S7, 'x') ; ssn(SB, 'x'))
        ) ; (
            ss(S9, _),
            o6(_, S9, S3, SA, SB, SC, SD),
            S9 \= S2,

            ss(SA, ' '),
            ss(SB, 'o'), ss(SC, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S9, 'x') ; ssn(SD, 'x'))
        ) ; (
            ss(S8, _),
            o6(_, S8, S9, S3, SA, SB, SC),
            S9 \= S2,

            ss(SA, ' '),
            ss(SB, 'o'), ss(S9, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S8, 'x') ; ssn(SC, 'x'))
        )
    ),

    tah_a(S3, 'D_CROSSX_DOWN', O).

% Deffence - zákeřný kříž
% nahoru

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    ss(S3, 'o'),
    (ss(S2, 'o') ; ss(S5, 'o')),

    ssn(S2, 'x'), ssn(S3, 'x'), ssn(S4, 'x'), ssn(S5, 'x'),

    (
        (
            ss(S6, _),
            o6(_, S6, S7, S8, S9, S4, SA),
            S9 \= S3,

            ss(S9, ' '),
            ss(S7, 'o'), ss(S8, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S6, 'x') ; ssn(SA, 'x'))
        ) ; (
            ss(S7, _),
            o6(_, S7, S8, S9, S4, SA, SB),
            S9 \= S3,

            ss(S9, ' '),
            ss(S8, 'o'), ss(SA, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S7, 'x') ; ssn(SB, 'x'))
        ) ; (
            ss(S9, _),
            o6(_, S9, S4, SA, SB, SC, SD),
            S9 \= S3,

            ss(SA, ' '),
            ss(SB, 'o'), ss(SC, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S9, 'x') ; ssn(SD, 'x'))
        ) ; (
            ss(S8, _),
            o6(_, S8, S9, S4, SA, SB, SC),
            S9 \= S3,

            ss(SA, ' '),
            ss(SB, 'o'), ss(S9, 'o'),
            (ssn(S1, 'x') ; ssn(SZ, 'x') ; ssn(S8, 'x') ; ssn(SC, 'x'))
        )
    ),

    tah_a(S4, 'D_CORSSX_UP', O).

% Offense - pokus o víc viditelnej kříž (možná posunout víc dolů ?)
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S2, 'O_CROSS_0', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S2, S7, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S2, 'O_CROSS_1', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S4, S7, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S4, 'O_CROSS_2', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S8, S4, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S4, 'O_CROSS_3', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S8, S2, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S2, 'O_CROSS_4', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S2, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S2, 'O_CROSS_5', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S4, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S4, 'O_CROSS_6', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S8, S3, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S3, 'O_CROSS_7', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S3, S7, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S3, 'O_CROSS_8', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ssn(S2, 'o'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S2, 'O_CROSS_9', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ssn(S5, 'o'),

    ss(S6, 'x'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ss(S6, 'x'), ss(S7, 'x'), ssn(S8, 'o'), ssn(S9, 'o'),
    tah_a(S3, 'O_CROSS_A', O).
tp :-
    ss(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ssn(S4, 'o'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'o'), ss(S7, 'x'), ss(S8, 'x'), ssn(S9, 'o'),
    tah_a(S3, 'O_CROSS_B', O).
tp :-
    ssn(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ssn(S5, 'o'),

    ssn(S6, 'o'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'o'), ssn(S7, 'o'), ss(S8, 'x'), ss(S9, 'x'),
    tah_a(S3, 'O_CROSS_C', O).

% Deffense - pokus o víc viditelnej kříž (možná posunout víc dolů ?)
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S2, 'D_CROSS_0', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S2, S7, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S2, 'D_CROSS_1', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S4, S7, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S4, 'D_CROSS_2', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S8, S4, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S4, 'D_CROSS_3', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S8, S2, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S2, 'D_CROSS_4', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S2, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S2, 'D_CROSS_5', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S4, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S4, 'D_CROSS_6', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S8, S3, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S3, 'D_CROSS_7', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S3, S7, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S3, 'D_CROSS_8', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ssn(S2, 'x'), ss(S3, ' '), ss(S4, 'o'), ss(S5, 'o'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S2, 'D_CROSS_9', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ssn(S5, 'x'),

    ss(S6, 'o'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ss(S6, 'o'), ss(S7, 'o'), ssn(S8, 'x'), ssn(S9, 'x'),
    tah_a(S3, 'D_CROSS_A', O).
tp :-
    ss(S1, 'o'), o(O, S1, S2, S3, S4, S5),
    ss(S1, 'o'), ss(S2, 'o'), ss(S3, ' '), ssn(S4, 'x'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'x'), ss(S7, 'o'), ss(S8, 'o'), ssn(S9, 'x'),
    tah_a(S3, 'D_CROSS_B', O).
tp :-
    ssn(S1, 'x'), o(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ssn(S5, 'x'),

    ssn(S6, 'x'), S1 \= S6, o(_, S6, S7, S3, S8, S9),
    ssn(S6, 'x'), ssn(S7, 'x'), ss(S8, 'o'), ss(S9, 'o'),
    tah_a(S3, 'D_CROSS_C', O).

%%%%% Paralelní linky 5. bod
tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S1, ' '), ss(S5, ' '),
    (ss(S2, 'x') ; ss(S4, 'x')), % dle předchozích bude 2 nebo 4 volné
    ssn(S2, 'o'), ssn(S4, 'o'),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'),
    o3(_, S6, S7, S8, S9, SA),
    (ss(S7, 'x') ; ss(S9, 'x')),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    (
        (tah_a(S2, 'GPT1', O)) ; (tah_a(S4, 'GPT2', O))
    ).

tp :-
    ss(S3, ' '), o3(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S1, ' '), ss(S4, 'x'), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'),
    o3(_, S6, S7, S8, S9, SA),
    (ss(S7, 'x') ; ss(S9, 'x')),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S3, 'GPT3', O).

% Obrana před paralelníma linkama
tp :-
    ss(S3, 'o'), o3(O, S1, S2, S3, S4, S5),
    (ss(S2, 'o') ; ss(S4, 'o')),
    ssn(S2, 'x'), ss(S1, ' '), ssn(S4, 'x'), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'o'), o3(_, S6, S7, S8, S9, SA),
    (ss(S7, 'o') ; ss(S9, 'o')), ss(S8, 'o'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(SD, 'GPT4', O).

% % Obrana před čtvercem
tp :-
    ss(S3, 'o'),
    o3(O, S1, S2, S3, S4, S5),
    ss(S8, 'o'),
    o3(_, S6, S7, S8, S9, SA),

    (
        (ssn(S1, 'x'), ssn(S2, 'x'), ssn(S4, 'x'), ssn(S5, 'x')) ;
        (ssn(S6, 'x'), ssn(S7, 'x'), ssn(S9, 'x'), ssn(SA, 'x'))
    ),

    (
        (ss(S2, 'o'), ss(S7, 'o')) ;
        (ss(S4, 'o'), ss(S9, 'o'))
    ),

    (
        (o3(_, SB, S3, S8, SC, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x')),
        (o3(_, SB, SC, S3, S8, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x')),
        (o3(_, SB, S2, S7, SC, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x')),
        (o3(_, SB, SC, S2, S7, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x')),
        (o3(_, SB, S4, S9, SC, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x')),
        (o3(_, SB, SC, S4, S9, SD), ssn(SB, 'x'), ssn(SC, 'x'), ssn(SD, 'x'))
    ),
    tah_a(SC, 'SQUARE_AVOID', O).

% % Paralelní linky - 4 bod
tp :-
    ss(S1, ' '), o(_, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S7, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S3, 'PA3_1', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S1, ' '), ss(S4, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S7, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S2, 'PA3_2', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S1, ' '), ss(S4, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S9, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S4, 'PA3_3', O).

tp :-
    ss(S3, ' '), o3(_, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S4, 'x'), ss(S1, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S8, 'x'), ss(S9, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S3, 'PA3_4', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S1, ' '), ss(S4, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S7, ' '), ss(S8, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S7, 'PA3_4', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S1, ' '), ss(S4, ' '), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, ' '), o3(_, S6, S7, S8, S9, SA),
    ss(S7, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S8, 'PA3_5', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S1, ' '), ss(S4, 'x'), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    ss(S8, 'x'), o3(_, S6, S7, S8, S9, SA),
    ss(S8, 'x'), ss(S9, ' '),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S9, 'PA3_6', O).

tp :-
    ss(S3, 'x'), o3(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S1, ' '), ss(S4, 'x'), ss(S5, ' '),

    vypocitej_fork(S1, S5, S6, SA),

    o(_, S6, S7, S8, S9, SA),
    ss(S8, ' '), ss(S9, 'x'),

    ss(SB, ' '), o(_, SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    ss(SB, ' '), ss(SD, ' '), ss(SF, ' '),

    tah_a(S8, 'PA3_7', O).

% Obrana před paralelníma linka pokud už jsem v prdeli :D
tp :-
    ss(S3, 'o'),
    o3(O, S1, S2, S3, S4, S5),
    ssn(S1, 'x'), ssn(S2, 'x'), ssn(S4, 'x'), ssn(S5, 'x'),

    vypocitej_fork(S1, S5, S6, SA),

    o(O, S6, S7, S8, S9, SA),
    S7 \= S2,
    S8 \= S3,
    ssn(S8, 'x'), ssn(S7, 'x'), ssn(S9, 'x'),

    ss(SB, _),
    (
        (
            (ss(S2, 'o') ; ss(S4, 'o')), ss(S8, 'o'),
            (o(_, SB, S3, SC, S8, _) ; o(_, SB, S8, SC, S3, _)),
            tah_a(SC, 'GPT5', O)
        ) ;
        (
            ss(S4, 'o'), ss(S9, 'o'),
            (o(_, SB, S4, SC, S9, _) ; o(_, SB, S9, SC, S4, _)),
            tah_a(SC, 'GPT6', O)
        ) ;
        (
            ss(S2, 'o'), ss(S7, 'o'),
            (o(_, SB, S2, SC, S7, _) ; o(_, SB, S7, SC, S2, _)),
            tah_a(SC, 'GPT7', O)
        )
    ).

% Robíme zákeřné kříže - položení čtvrtého pole
tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S6, _),
    o6(_, S6, S7, S8, S9, S3, SA),
    S9 \= S2,

    ss(S9, ' '),
    (ssn(S6, 'o'), ssn(S7, 'o'), ssn(S8, 'o'), ssn(SA, 'o')),
    (ss(S7, 'x'), ss(S8, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S2, 'GPT8', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT9', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S5, 'GPT10', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT11', O)
        ) ;
        (
            ss(S7, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S8, 'x'),
            tah_a(S7, 'GPT12', O)
        ) ;
        (
            ss(S8, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S7, 'x'),
            tah_a(S8, 'GPT13', O)
        )
    ).

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S7, _),
    o6(_, S7, S8, S9, S3, SA, SB),
    S9 \= S2,

    ss(S9, ' '),
    (ssn(S7, 'o'), ssn(S8, 'o'), ssn(SA, 'o'), ssn(SB, 'o')),
    (ss(SA, 'x'), ss(S8, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S2, 'GPT14', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT15', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S5, 'GPT16', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT17', O)
        ) ;
        (
            ss(SA, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S8, 'x'),
            tah_a(SA, 'GPT18', O)
        ) ;
        (
            ss(S8, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SA, 'x'),
            tah_a(S8, 'GPT19', O)
        )
    ).

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S9, _),
    o6(_, S9, S3, SA, SB, SC, SD),
    S9 \= S2,

    ss(SA, ' '),
    ssn(SD, 'o'), ssn(SB, 'o'), ssn(SC, 'o'), ssn(S9, 'o'),
    (ss(SB, 'x') ; ss(SC, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(SC, 'x'), ss(SB, 'x'),
        tah_a(S2, 'GPT20', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT21', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S5, 'GPT22', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT23', O)
        ) ;
        (
            ss(SC, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SB, 'x'),
            tah_a(SC, 'GPT24', O)
        ) ;
        (
            ss(SB, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SC, 'x'),
            tah_a(SB, 'GPT25', O)
        )
    ).

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S3, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S8, _),
    o6(_, S8, S9, S3, SA, SB, SC),
    S9 \= S2,

    ss(SA, ' '),
    ssn(SC, 'o'), ssn(SB, 'o'), (ss(S9, 'x'), ss(S9, ' ')), ssn(S8, 'o'),
    (ss(SB, 'x') ; ss(S9, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S2, 'GPT26', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT27', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S5, 'GPT28', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT29', O)
        ) ;
        (
            ss(S9, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SB, 'x'),
            tah_a(S9, 'GPT30', O)
        ) ;
        (
            ss(SB, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S9, 'x'),
            tah_a(SB, 'GPT31', O)
        )
    ).

% Tah počítače - nejzákeřnější kříž - nahoru
tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S6, _),
    o6(_, S6, S7, S8, S9, S4, SA),
    S9 \= S3,

    ss(S9, ' '),
    (ssn(S6, 'o'), ssn(S7, 'o'), ssn(S8, 'o'), ssn(SA, 'o')),
    (ss(S7, 'x'), ss(S8, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S2, 'GPT32', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT33', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S5, 'GPT34', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(S7, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT35', O)
        ) ;
        (
            ss(S7, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S8, 'x'),
            tah_a(S7, 'GPT36', O)
        ) ;
        (
            ss(S8, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S7, 'x'),
            tah_a(S8, 'GPT37', O)
        )
    ).
tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S7, _),
    o6(_, S7, S8, S9, S4, SA, SB),
    S9 \= S3,

    ss(S9, ' '),
    (ssn(S7, 'o'), ssn(S8, 'o'), ssn(SA, 'o'), ssn(SB, 'o')),
    (ss(SA, 'x'), ss(S8, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S2, 'GPT38', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT39', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S5, 'GPT40', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(SA, 'x'), ss(S8, 'x'),
            tah_a(S4, 'GPT41', O)
        ) ;
        (
            ss(SA, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S8, 'x'),
            tah_a(SA, 'GPT42', O)
        ) ;
        (
            ss(S8, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SA, 'x'),
            tah_a(S8, 'GPT43', O)
        )
    ).

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S9, _),
    o6(_, S9, S4, SA, SB, SC, SD),
    S9 \= S3,

    ss(SA, ' '),
    ssn(SD, 'o'), ssn(SB, 'o'), ssn(SC, 'o'), ssn(S9, 'o'),
    (ss(SB, 'x') ; ss(SC, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S2, 'GPT44', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT45', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S5, 'GPT46', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(SC, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT47', O)
        ) ;
        (
            ss(SC, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SB, 'x'),
            tah_a(SC, 'GPT48', O)
        ) ;
        (
            ss(SB, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SC, 'x'),
            tah_a(SB, 'GPT49', O)
        )
    ).

tp :-
    ss(S1, _), o6(O, S1, S2, S3, S4, S5, SZ),
    ss(S4, ' '),
    (
        ((ss(S2, 'x') ; ss(S4, 'x')), ssn(S1, 'o')) ;
        ((ss(S4, 'x') ; ss(S5, 'x')), ssn(SZ, 'o'))
    ),
    ssn(S2, 'o'), ssn(S3, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    ss(S8, _),
    o6(_, S8, S9, S4, SA, SB, SC),
    S9 \= S3,

    ss(SA, ' '),
    ssn(SC, 'o'), ssn(SB, 'o'), (ss(S9, 'x'), ss(S9, ' ')), ssn(S8, 'o'),
    (ss(SB, 'x') ; ss(S9, 'x')),

    (
        (
            ssn(S1, 'o'), ss(S2, ' '), ss(S4, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S2, 'GPT50', O)
        ) ;
        (
            ssn(S1, 'o'), ss(S4, ' '), ss(S2, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT51', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S5, ' '), ss(S4, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S5, 'GPT52', O)
        ) ;
        (
            ssn(SZ, 'o'), ss(S4, ' '), ss(S5, 'x'), ss(S9, 'x'), ss(SB, 'x'),
            tah_a(S4, 'GPT53', O)
        ) ;
        (
            ss(S9, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(SB, 'x'),
            tah_a(S9, 'GPT54', O)
        ) ;
        (
            ss(SB, ' '), ((ss(S2, 'x') ; ss(S4, 'x')) ; (ss(S4, 'x') ; ss(S5, 'x'))), ss(S9, 'x'),
            tah_a(SB, 'GPT55', O)
        )
    ).

% Kříže - položení čtvrtého pole
% Kříž doprava
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S3, 'GPT56', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S4, 'GPT57', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, ' '), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S7, 'GPT58', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, 'x'), ss(S8, ' '), ss(S9, ' '),
    tah_a(S8, 'GPT59', O).

% To samé, ale kříž doleva
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S7 \= S3,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S3, 'GPT60', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S7 \= S3,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S2, 'GPT61', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S7 \= S3,
    ss(S7, ' '), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S7, 'GPT62', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(O, S6, S7, S4, S8, S9), S7 \= S3,
    ss(S7, 'x'), ss(S8, ' '), ss(S9, ' '),
    tah_a(S8, 'GPT63', O).

% Najdu vidličku která má prázdné pozice a zkouším pokládat
tp :-
    ss(S3, 'x'),
    o3(_, S1, S2, S3, S4, S5),
    ssn(S1, 'o'), ssn(S2, 'o'), ssn(S4, 'o'), ssn(S5, 'o'),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (
            S1X = S6X, S5X = SAX,
            ((SAY is S5Y-2, S6Y is S1Y-2) ; (SAY is S5Y+2, S6Y is S1Y+2))
        ) ;
        (
            S1Y = S6Y, S5Y = SAY,
            (SAX is S5X-2, S6X is S1X-2; SAX is S5X+2, S6X is S1X+2)
        )
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    o(O, S6, S7, S8, S9, SA),
    S3 \= S8, S2 \= S7,
    ssn(S8, 'o'),
    ssn(S7, 'o'),ssn(S9, 'o'),

    (
        (
            ss(S2, 'x'), ss(S7, 'x'), ss(S3, ' '),
            tah_a(S3, 'GPT64', -1)
        ) ;
        (
            ss(S3, 'x'), ss(S8, 'x'), ss(S6, ' '),
            tah_a(S2, 'GPT65', O)
        ) ;
        (
            ss(S3, 'x'), ss(S8, 'x'), ss(S9, ' '),
            tah_a(S4, 'GPT66', O)
        ) ;
        (
            ss(S4, 'x'), ss(S9, 'x'), ss(S3, ' '),
            tah_a(S3, 'GPT67', O)
        )
    ).



% Robíme kříže - položení třetího pole
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S8, 'GPT68', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S8, 'GPT69', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S3, 'GPT70', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, 'x'), ss(S8, 'x'), ss(S9, ' '),
    tah_a(S3, 'GPT71', O).

% Robíme kříže - položení druhého pole
% Doprava
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S4, 'GPT72', O).

tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S3, 'GPT73', O).

% Doleva
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S2, 'GPT74', O).
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S3, 'GPT75', O).

% Robíme kříže - položení prvního pole
% Doprava
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S2, S8, S9), S8 \= S3,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S3, 'GPT76', O).
% Doleva
tp :-
    ss(S1, ' '), o(O, S1, S2, S3, S4, S5),
    ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '),
    ss(S6, ' '), o(_, S6, S7, S4, S8, S9), S8 \= S5,
    ss(S7, ' '), ss(S8, ' '), ss(S9, ' '),
    tah_a(S3, 'GPT77', O).

tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'O_DOP_3_1', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S2, 'O_DOP_3_2', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'o_DOP_3_3', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'o_DOP_3_4', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '), tah_a(S5, 'o_DOP_3_5', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'o_DOP_3_6', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'o_DOP_3_7', O).

% Útok doplnění 3 -> 4
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'O_DOP_3_1', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S2, 'O_DOP_3_2', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'o_DOP_3_3', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'o_DOP_3_4', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '), tah_a(S5, 'o_DOP_3_5', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'o_DOP_3_6', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'o_DOP_3_7', O).

% Útok doplnění 2 -> 3
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, 'x'), tah_a(S2, 'o_DOP_2_1', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'o_DOP_2_2', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), tah_a(S1, 'o_DOP_2_3', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '), tah_a(S5, 'o_DOP_2_4', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '), tah_a(S5, 'o_DOP_2_5', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'o_DOP_2_6', O).

% Útok doplnění 1 -> 2
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '), tah_a(S2, 'o_DOP_1_1', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, ' '), ss(S4, ' '), ss(S5, ' '), tah_a(S4, 'o_DOP_1_2', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, ' '), ss(S5, ' '), tah_a(S1, 'o_DOP_1_3', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, ' '), ss(S4, 'x'), ss(S5, ' '), tah_a(S2, 'o_DOP_1_4', O).
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, ' '), ss(S3, ' '), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'o_DOP_1_5', O).

% random tah
tp :-   ss(S, ' '),
        retract(ss(S,' ')),
        assert(ss(S,x)),
        v_pole, nl, write('Náhodný tah: '), write(S),
        test_v(x).

c_pole :-   assert(ss([4,4], ' ')),
            assert(ss([5,4], ' ')),
            assert(ss([5,5], ' ')),
            assert(ss([4,5], ' ')),

            assert(ss([3,5], ' ')),
            assert(ss([3,4], ' ')),
            assert(ss([3,3], ' ')),
            assert(ss([4,3], ' ')),
            assert(ss([5,3], ' ')),
            assert(ss([6,3], ' ')),
            assert(ss([6,4], ' ')),
            assert(ss([6,5], ' ')),
            assert(ss([6,6], ' ')),
            assert(ss([5,6], ' ')),
            assert(ss([4,6], ' ')),
            assert(ss([3,6], ' ')),

            assert(ss([2,6], ' ')),
            assert(ss([2,5], ' ')),
            assert(ss([2,4], ' ')),
            assert(ss([2,3], ' ')),
            assert(ss([2,2], ' ')),
            assert(ss([3,2], ' ')),
            assert(ss([4,2], ' ')),
            assert(ss([5,2], ' ')),
            assert(ss([6,2], ' ')),
            assert(ss([7,2], ' ')),
            assert(ss([7,3], ' ')),
            assert(ss([7,4], ' ')),
            assert(ss([7,5], ' ')),
            assert(ss([7,6], ' ')),
            assert(ss([7,7], ' ')),
            assert(ss([6,7], ' ')),
            assert(ss([5,7], ' ')),
            assert(ss([4,7], ' ')),
            assert(ss([3,7], ' ')),
            assert(ss([2,7], ' ')),

            assert(ss([1,7], ' ')),
            assert(ss([1,6], ' ')),
            assert(ss([1,5], ' ')),
            assert(ss([1,4], ' ')),
            assert(ss([1,3], ' ')),
            assert(ss([1,2], ' ')),
            assert(ss([1,1], ' ')),
            assert(ss([2,1], ' ')),
            assert(ss([3,1], ' ')),
            assert(ss([4,1], ' ')),
            assert(ss([5,1], ' ')),
            assert(ss([6,1], ' ')),
            assert(ss([7,1], ' ')),
            assert(ss([8,1], ' ')),
            assert(ss([8,2], ' ')),
            assert(ss([8,3], ' ')),
            assert(ss([8,4], ' ')),
            assert(ss([8,5], ' ')),
            assert(ss([8,6], ' ')),
            assert(ss([8,7], ' ')),
            assert(ss([8,8], ' ')),
            assert(ss([7,8], ' ')),
            assert(ss([6,8], ' ')),
            assert(ss([5,8], ' ')),
            assert(ss([4,8], ' ')),
            assert(ss([3,8], ' ')),
            assert(ss([2,8], ' ')),
            assert(ss([1,8], ' ')),

            assert(ss([0,8], ' ')),
            assert(ss([0,7], ' ')),
            assert(ss([0,6], ' ')),
            assert(ss([0,5], ' ')),
            assert(ss([0,4], ' ')),
            assert(ss([0,3], ' ')),
            assert(ss([0,2], ' ')),
            assert(ss([0,1], ' ')),
            assert(ss([0,0], ' ')),
            assert(ss([1,0], ' ')),
            assert(ss([2,0], ' ')),
            assert(ss([3,0], ' ')),
            assert(ss([4,0], ' ')),
            assert(ss([5,0], ' ')),
            assert(ss([6,0], ' ')),
            assert(ss([7,0], ' ')),
            assert(ss([8,0], ' ')),
            assert(ss([9,0], ' ')),
            assert(ss([9,1], ' ')),
            assert(ss([9,2], ' ')),
            assert(ss([9,3], ' ')),
            assert(ss([9,4], ' ')),
            assert(ss([9,5], ' ')),
            assert(ss([9,6], ' ')),
            assert(ss([9,7], ' ')),
            assert(ss([9,8], ' ')),
            assert(ss([9,9], ' ')),
            assert(ss([8,9], ' ')),
            assert(ss([7,9], ' ')),
            assert(ss([6,9], ' ')),
            assert(ss([5,9], ' ')),
            assert(ss([4,9], ' ')),
            assert(ss([3,9], ' ')),
            assert(ss([2,9], ' ')),
            assert(ss([1,9], ' ')),
            assert(ss([0,9], ' ')).
