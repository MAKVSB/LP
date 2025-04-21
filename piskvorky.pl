:- dynamic ss/2.
:- dynamic is_empty_flag/1.
:- dynamic krok/3.
:- dynamic game/3.

cisla(X,X,[X]) :- !.
cisla(A,X,[A|R]) :- A<X, A1 is A+1, cisla(A1, X, R).

reset :- retractall(ss(_,_)), retractall(krok(_,_, _)).
start :- c_pole, v_pole.

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

o(4, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y-1, Y2 is Y-2, Y3 is Y-3, Y4 is Y-4.
o(1, [X,Y], [X1, Y], [X2, Y], [X3,Y], [X4,Y]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4.
o(3, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.
o(2, [X,Y], [X, Y1], [X, Y2], [X,Y3], [X,Y4]) :- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.




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

% ok(   source, top,     top-right, right,  bottom-right, bottom,  bottom-left, left,    top-left)
% ok(100, [X,Y], [X, YT], [XR,YT], [XR,Y], [XR,YB], [X, YB], [XL,YB], [XL,Y], [XL, YT]): XL is X-1, XR is X+1, YT is Y+1, YB is Y-1.

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












tah_a([X,Y]) :- !, retract(ss([X,Y],' ')), assert(ss([X,Y], 'x')), v_pole, nl, write('Tah :['), write(X), write(','), write(Y), write(']'), map(MAP), assert(krok([X,Y],'x',MAP)), test_v(x).
tah_a([X,Y], RULE, O) :- !, retract(ss([X,Y],' ')), assert(ss([X,Y], 'x')), v_pole, nl, write('Tah '), write(RULE), write(' '), write(O), write(': ['), write(X), write(','), write(Y), write(']'), map(MAP), assert(krok([X,Y],'x',MAP)), test_v(x).

% pravidla ZDE
%_________________________________________________________________________________________

% UTOK: doplnění 4 -> 5
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S1, 'O_DOP_1', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), tah_a(S2, 'O_DOP_2', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), tah_a(S3, 'O_DOP_3', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, 'x'), tah_a(S4, 'O_DOP_4', O).
tp :- ss(S1, 'x'), o(O, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '), tah_a(S5, 'O_DOP_5', O).

% obrana: vyblokování 4 -> 5
tp :- ss(S1, ' '), o(O, S1, S2, S3, S4, S5), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), tah_a(S1, 'D_DOP_1', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), tah_a(S2, 'D_DOP_2', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ss(S5, 'o'), tah_a(S3, 'D_DOP_3', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ss(S5, 'o'), tah_a(S4, 'D_DOP_4', O).
tp :- ss(S1, 'o'), o(O, S1, S2, S3, S4, S5), ss(S1, 'o'), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, ' '), tah_a(S5, 'D_DOP_5', O).

% Defense do 4 trochu chytřejší
% oponent není debil a umí blokovat trojice/čtveřice - tedy čtveřici je třeba tvořit pouze pokud je trojice volná z obou stran.
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, ' '), ss(S3, 'o'), ss(S4, 'o'), ss(S5, 'o'), ss(S6, ' '), tah_a(S2, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, ' '), ss(S4, 'o'), ss(S5, 'o'), ss(S6, ' '), tah_a(S3, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, ' '), ss(S5, 'o'), ss(S6, ' '), tah_a(S4, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'o'), ss(S3, 'o'), ss(S4, 'o'), ss(S5, ' '),  ss(S6, ' '), tah_a(S5, 'D_DOP_4B_1', O).

% Útok doplnění 3 -> 4 s ochranou okolí
% oponent není debil a umí blokovat trojice/čtveřice - tedy čtveřici je třeba tvořit pouze pokud je trojice volná z obou stran.
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, ' '), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x'), ss(S6, ' '), tah_a(S2, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, ' '), ss(S4, 'x'), ss(S5, 'x'), ss(S6, ' '), tah_a(S3, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, ' '), ss(S5, 'x'), ss(S6, ' '), tah_a(S4, 'D_DOP_4B_1', O).
tp :- ss(S1, ' '), o6(O, S1, S2, S3, S4, S5, S6), ss(S1, ' '), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, ' '),  ss(S6, ' '), tah_a(S5, 'D_DOP_4B_1', O).

% Obrana proti vzniku kříže:
%     _
%     o
% _ o P o _
%     o
%     _
tp :-   ss(CC, ' '), o3(AID, A1, A2, CC, A4, A5),
        ss_is(A1), ss(A2, 'o'), ss(A4, 'o'), ss_is(A5),
        o3(BID, B1, B2, CC, B4, B5),
        ss_is(B1), ss(B2, 'o'), ss(B4, 'o'), ss_is(B5),
        tah_a(CC, 'D_CEN_1', AID).

% Útok na kříž:
%     _
%     x
% _ x P x _
%     x
%     _
tp :-   ss(CC, ' '), o3(AID, A1, A2, CC, A4, A5),
        ss_is(A1), ss(A2, 'x'), ss(A4, 'x'), ss_is(A5),
        o3(BID, B1, B2, CC, B4, B5),
        ss_is(B1), ss(B2, 'x'), ss(B4, 'x'), ss_is(B5),
        tah_a(CC, 'D_CEN_1', AID).






























































































































%Tah počítače : pravidlo 4 Xxxx
%Předpoklad - oponent není debil a umí blokovat trojice/čtveřice - tedy čtveřici je třeba tvořit pouze pokud je trojice volná z obou stran.
tp :-
    s(S1, ' '),
    o6(S1, S2, S3, S4, S5, S6),
    s(S2, ' '), s(S3, o), s(S4, o), s(S5, o),
    (s(S6, ' '); s(S6, o)),
    retract(s(S2, ' ')), assert(s(S2, x)),
    write([S2, 4]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 4 xXxx
tp :-
    s(S1, ' '),
    o6(S1, S2, S3, S4, S5, S6),
    s(S2, o), s(S3, ' '), s(S4, o), s(S5, o),
    s(S6, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 4]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 4 xxXx
tp :-
    s(S1, ' '),
    o6(S1, S2, S3, S4, S5, S6),
    s(S2, o), s(S3, o), s(S4, ' '), s(S5, o),
    s(S6, ' '),
    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 4]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 4 xxxX
tp :-
    s(S1, ' '),
    o6(S1, S2, S3, S4, S5, S6),
    s(S2, o), s(S3, o), s(S4, o), s(S5, ' '), 
    s(S6, ' '),
    retract(s(S5, ' ')), assert(s(S5, x)),
    write([S5, 4]), nl,
    vypis_p,
    test_v(x).

% Kříže

% Offense - kříž

% Tah počítače - pravidlo 30 - zákeřnější kříž - dolů z obou stran

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, x), s(S4, x)); 
        (s(S4, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S3, SA),
    S9 \= S2,
    
    s(S9, ' '),
    (s(S7, x), s(S8, x)),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S6, ' '); s(S6, o)); (s(SA, ' '); s(SA, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, x), s(S4, x)); 
        (s(S4, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S3, SA, SB),
    S9 \= S2,
    
    s(S9, ' '),
    (s(S8, x), s(SA, x)),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S7, ' '); s(S7, o)); (s(SB, ' '); s(SB, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, x), s(S4, x)); 
        (s(S4, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S9, _),
    o6(S9, S3, SA, SB, SC, SD),
    S9 \= S2,
    
    s(SA, ' '),
    s(SB, x), s(SC, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S9, ' '); s(S9, o)); (s(SD, ' '); s(SD, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, x), s(S4, x)); 
        (s(S4, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S8, _),
    o6(S8, S9, S3, SA, SB, SC),
    S9 \= S2,
    
    s(SA, ' '),
    s(SB, x), s(S9, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S8, ' '); s(S8, o)); (s(SC, ' '); s(SC, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 30]), nl,
    vypis_p,
    test_v(x).

% Tah počítače - pravidlo 30 - zákeřnější kříž - nahoru z obou stran

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, x), s(S3, x)); 
        (s(S3, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),
    (s(SZ, x); s(SZ, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S4, SA),
    S9 \= S3,
    
    s(S9, ' '),
    s(S7, x), s(S8, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S6, ' '); s(S6, o)); (s(SA, ' '); s(SA, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, x), s(S3, x)); 
        (s(S3, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),
    (s(SZ, x); s(SZ, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S4, SA, SB),
    S9 \= S3,
    
    s(S9, ' '),
    s(S8, x), s(SA, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S7, ' '); s(S7, o)); (s(SB, ' '); s(SB, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, x), s(S3, x)); 
        (s(S3, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),
    (s(SZ, x); s(SZ, ' ')),

    s(S9, _),
    o6(S9, S4, SA, SB, SC, SD),
    S9 \= S3,
    
    s(SA, ' '),
    s(SB, x), s(SC, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S9, ' '); s(S9, o)); (s(SD, ' '); s(SD, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 30]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, x), s(S3, x)); 
        (s(S3, x), s(S5, x))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),
    (s(SZ, x); s(SZ, ' ')),

    s(S8, _),
    o6(S8, S9, S4, SA, SB, SC),
    S9 \= S3,
    
    s(SA, ' '),
    s(SB, x), s(S9, x),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S8, ' '); s(S8, o)); (s(SC, ' '); s(SC, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 30]), nl,
    vypis_p,
    test_v(x).

% Obrana

% Tah počítače - pravidlo 30 - zákeřnější kříž - dolů z obou stran

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, o), s(S4, o)); 
        (s(S4, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S3, SA),
    S9 \= S2,
    
    s(S9, ' '),
    (s(S7, o), s(S8, o)),

    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S6, ' '); s(S6, o)); (s(SA, ' '); s(SA, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 31]), nl,

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, o), s(S4, o)); 
        (s(S4, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S3, SA, SB),
    S9 \= S2,
    
    s(S9, ' '),
    s(S8, o), s(SA, o),

    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S7, ' '); s(S7, o)); (s(SB, ' '); s(SB, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 31]), nl,

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, o), s(S4, o)); 
        (s(S4, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S9, _),
    o6(S9, S3, SA, SB, SC, SD),
    S9 \= S2,

    s(SA, ' '),
    s(SB, o), s(SC, o),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S9, ' '); s(S9, o)); (s(SD, ' '); s(SD, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 32]), nl,

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        (s(S2, o), s(S4, o)); 
        (s(S4, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S8, _),
    o6(S8, S9, S3, SA, SB, SC),
    S9 \= S2,

    s(SA, ' '),
    s(SB, o), s(S9, o),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S8, ' '); s(S8, o)); (s(SC, ' '); s(SC, o))
    ),

    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 32]), nl,

    vypis_p,
    test_v(x).

% Tah počítače - pravidlo 30 - zákeřnější kříž - nahoru z obou stran

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, o), s(S3, o)); 
        (s(S3, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S4, SA),
    S9 \= S3,
    
    s(S9, ' '),
    s(S7, o), s(S8, o),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S6, ' '); s(S6, o)); (s(SA, ' '); s(SA, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 33]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, o), s(S3, o)); 
        (s(S3, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S4, SA, SB),
    S9 \= S3,
    
    s(S9, ' '),
    s(S8, o), s(SA, o),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S7, ' '); s(S7, o)); (s(SB, ' '); s(SB, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 33]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, o), s(S3, o)); 
        (s(S3, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S9, _),
    o6(S9, S4, SA, SB, SC, SD),
    S9 \= S3,
    
    s(SA, ' '),
    s(SB, o), s(SC, o),
    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S9, ' '); s(S9, o)); (s(SD, ' '); s(SD, o))
    ),

    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 34]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        (s(S2, o), s(S3, o)); 
        (s(S3, o), s(S5, o))
    ),
    (s(S2, o); s(S2, ' ')),
    (s(S3, o); s(S3, ' ')),
    (s(S4, o); s(S4, ' ')),
    (s(S5, o); s(S5, ' ')),

    s(S8, _),
    o6(S8, S9, S4, SA, SB, SC),
    S9 \= S3,
    
    s(SA, ' '),
    s(SB, o), s(S9, o),

    (
        (s(S1, ' '); s(S1, o)); (s(SZ, ' '); s(SZ, o));
        (s(S8, ' '); s(S8, o)); (s(SC, ' '); s(SC, o))
    ),


    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 34]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 2 kříž
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, ' '), s(S4, x), s(S5, ' '),
    s(S6, ' '), S1 \= S6, o(S6, S7, S3, S8, S9),
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 2]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 2 kříž
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, x), s(S5, ' '),
    s(S6, ' '), S1 \= S6, o(S6, S2, S7, S8, S9),
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 2]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 2 kříž ukazující doprava
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, x), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9),
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 2]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 2 kříž ukazující doleva
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9),
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 2]), nl,
    vypis_p,
    test_v(x).

% Defense - kříž

%Tah počítače : pravidlo 3 kříž
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, o), s(S3, ' '), s(S4, o), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), S1 \= S6, o(S6, S7, S3, S8, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 3 kříž
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, o), s(S4, o), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), S1 \= S6, o(S6, S2, S7, S8, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S2, ' ')), assert(s(S2, x)),
    write([S2, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 3 kříž
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, o), s(S3, o), s(S4, ' '), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), S1 \= S6, o(S6, S7, S8, S4, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 3 kříž
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, o), s(S4, o), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), S3 \= S6, o(S6, S4, S7, S8, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače : pravidlo 3 kříž
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, o), s(S4, o), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), S1 \= S6, o(S6, S7, S8, S2, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S2, ' ')), assert(s(S2, x)),
    write([S2, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 3 kříž ukazující doprava
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, o), s(S4, o), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), o(S6, S7, S2, S8, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 3]), nl,
    vypis_p,
    test_v(x).

%Tah počítače - pravidlo 3 kříž ukazující doleva
tp :-
    (s(S1, ' '); s(S1, o)), o(S1, S2, S3, S4, S5),
    s(S2, o), s(S3, o), s(S4, ' '), (s(S5, ' '); s(S5, o)),
    (s(S6, ' '); s(S6, o)), o(S6, S7, S4, S8, S9),
    s(S7, o), s(S8, o), (s(S9, ' '); s(S9, o)),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 3]), nl,
    vypis_p,
    test_v(x).

% Robíme paralelní trojice - položení pátého pole, pravidlo 14

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S1, ' '), s(S5, ' '),
    (s(S2, x); s(S4, x)),
    (s(S2, ' '); s(S2, x)), (s(S4, x); s(S4, ' ')),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x),
    o3(S6, S7, S8, S9, SA),
    (s(S7, x); s(S9, x)),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 14]), nl);
        (retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 14]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, ' '), o3(S1, S2, S3, S4, S5),
    s(S2, x), s(S1, ' '), s(S4, x), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), 
    o3(S6, S7, S8, S9, SA),
    (s(S7, x); s(S9, x)),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S3, ' ')), assert(s(S3, x)), write([S3, 14]), nl)
    ),
    vypis_p,
    test_v(x).

% Obrana před paralelníma dvojicema/trojicema/jak tomu chcu říkat - pro dvě
% paralelní dvojice, ale to už je trochu pozdě - pravidlo 60
tp :-
    s(S3, o), o3(S1, S2, S3, S4, S5),
    (s(S2, o); s(S4, o)),
    (s(S2, ' '); s(S2, o)), s(S1, ' '), (s(S4, o); s(S4, ' ')), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, o), o3(S6, S7, S8, S9, SA),
    (s(S7, o); s(S9, o)), s(S8, o),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(SD, ' ')), assert(s(SD, x)), write([SD, 60]), nl)
    ),
    vypis_p,
    test_v(x).

% Obrana před čtvercem

tp :-
    s(S3, o),
    o3(S1, S2, S3, S4, S5),
    s(S8, o),
    o3(S6, S7, S8, S9, SA),

    (
        ((s(S1, ' '); s(S1, o)), (s(S2, ' '); s(S2, o)), (s(S4, ' '); s(S4, o)), (s(S5, ' '); s(S5, o)));
        ((s(S6, ' '); s(S6, o)), (s(S7, ' '); s(S7, o)), (s(S9, ' '); s(S9, o)), (s(SA, ' '); s(SA, o)))
    ),
        
    (
        (s(S2, o), s(S7, o));
        (s(S4, o), s(S9, o))
    ),

    (
        (o3(SB, S3, S8, SC, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o))),
        (o3(SB, SC, S3, S8, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o))),
        (o3(SB, S2, S7, SC, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o))),
        (o3(SB, SC, S2, S7, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o))),
        (o3(SB, S4, S9, SC, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o))),
        (o3(SB, SC, S4, S9, SD), (s(SB, ' '); s(SB, o)), (s(SC, ' '); s(SC, o)), (s(SD, ' '); s(SD, o)))
    ),
    retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 110]), nl.

% Robíme paralelní trojice - položení čtvrtého pole, pravidlo 15

tp :-
    s(S2, x), o2(S1, S2, S3, S4, S5),
    s(S1, ' '), s(S3, ' '), s(S4, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S7, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S3, ' ')), assert(s(S3, x)), write([S3, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S1, ' '), s(S4, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S7, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S1, ' '), s(S4, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S9, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S4, x), o4(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S1, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S8, x), s(S9, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S3, ' ')), assert(s(S3, x)), write([S3, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, x), s(S1, ' '), s(S4, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S7, ' '), s(S8, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S7, ' ')), assert(s(S7, x)), write([S7, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, x), s(S1, ' '), s(S4, ' '), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S7, x), o2(S6, S7, S8, S9, SA),
    s(S7, x), s(S8, ' '),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S1, ' '), s(S4, x), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S8, x), o3(S6, S7, S8, S9, SA),
    s(S8, x), s(S9, ' '),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S9, ' ')), assert(s(S9, x)), write([S9, 15]), nl)
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S3, x), o3(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S1, ' '), s(S4, x), s(S5, ' '),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    s(S9, x), o4(S6, S7, S8, S9, SA),
    s(S8, ' '), s(S9, x),

    s(SB, ' '), o(SB, SC, SD, SE, SF),
    SB \= S1, SB \= S6,
    (SC = S2; SC = S7), (SE = S4; SE = S9),
    s(SB, ' '), s(SD, ' '), s(SF, ' '),

    (
        (retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 15]), nl)
    ),
    vypis_p,
    test_v(x).

% Obrana před paralelními dvojicemi/trojicemi, pravidlo 20 - je třeba provést, dokud
% soupeř položil pouze tři pole, jinak je pozdě
tp :-
    s(S3, o),
    o3(S1, S2, S3, S4, S5),
    (s(S1, ' '); s(S1, o)), (s(S2, ' '); s(S2, o)), (s(S4, ' '); s(S4, o)), (s(S5, ' '); s(S5, o)),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (S1X = S6X, (S6Y is S1Y-2; S6Y is S1Y+2));
        (S1Y = S6Y, (S6X is S1X-2; S6X is S1X+2))
    ),
    (
        (SAX = S5X, (SAY is S5Y-2; SAY is S5Y+2));
        (SAY = S5Y, (SAX is S5X-2; SAX is S5X+2))
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    o(S6, S7, S8, S9, SA),
    S7 \= S2,
    S8 \= S3,
    (s(S8, ' '); s(S8, o)),
    (s(S7, ' '); s(S7, o)),(s(S9, ' '); s(S9, o)),

    s(SB, _),
    (
        (
            (s(S2, o); s(S4, o)), s(S8, o), 
            (o(SB, S3, SC, S8, SE); o(SB, S8, SC, S3, SE)),
            retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 20]), nl
        );
        (
            s(S4, o), s(S9, o), 
            (o(SB, S4, SC, S9, SE); o(SB, S9, SC, S4, SE)),
            retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 20]), nl
        );
        (
            s(S2, o), s(S7, o), 
            (o(SB, S2, SC, S7, SE); o(SB, S7, SC, S2, SE)),
            retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 20]), nl
        )
    ),
    vypis_p,
    test_v(x).

% Robíme zákeřné kříže - položení čtvrtého pole, pravidlo 31

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S3, SA),
    S9 \= S2,
    
    s(S9, ' '),
    ((s(S6, ' '); s(S6, x)), (s(S7, x); s(S7, ' ')), (s(S8, x); s(S8, ' ')), (s(SA, ' '); s(SA, x))),
    (s(S7, x), s(S8, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(S7, x), s(S8, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(S7, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(S7, x), s(S8, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(S7, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(S7, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S8, x),
            retract(s(S7, ' ')), assert(s(S7, x)), write([S7, 32]), nl
        );
        (
            s(S8, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S7, x),
            retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 32]), nl
        )
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S3, SA, SB),
    S9 \= S2,
    
    s(S9, ' '),
    ((s(S7, x); s(S7, ' ')), (s(S8, x); s(S8, ' ')), (s(SA, x); s(SA, ' ')), (s(SB, ' '); s(SB, x))),
    (s(SA, x), s(S8, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(SA, x), s(S8, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(SA, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(SA, x), s(S8, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(SA, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(SA, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S8, x),
            retract(s(SA, ' ')), assert(s(SA, x)), write([SA, 32]), nl
        );
        (
            s(S8, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SA, x),
            retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S9, _),
    o6(S9, S3, SA, SB, SC, SD),
    S9 \= S2,
    
    s(SA, ' '),
    (s(SD, ' '); s(SD, x)), (s(SB, x); s(SB, ' ')), (s(SC, x); s(SC, ' ')), (s(S9, ' '); s(S9, x)),
    (s(SB, x); s(SC, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(SC, x), s(SB, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(SC, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(SC, x), s(SB, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(SC, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(SC, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SB, x),
            retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 32]), nl
        );
        (
            s(SB, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SC, x),
            retract(s(SB, ' ')), assert(s(SB, x)), write([SB, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S3, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S8, _),
    o6(S8, S9, S3, SA, SB, SC),
    S9 \= S2,
    
    s(SA, ' '),
    (s(SC, x); s(SC, ' ')), (s(SB, x); s(SB, ' ')), (s(S9, x), s(S9, ' ')), (s(S8, ' '); s(S8, x)),
    (s(SB, x); s(S9, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(S9, x), s(SB, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(S9, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(S9, x), s(SB, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(S9, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(S9, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SB, x),
            retract(s(S9, ' ')), assert(s(S9, x)), write([S9, 32]), nl
        );
        (
            s(SB, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S9, x),
            retract(s(SB, ' ')), assert(s(SB, x)), write([SB, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

% Tah počítače - pravidlo 30 - zákeřnější kříž - nahoru z obou stran

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S6, _),
    o6(S6, S7, S8, S9, S4, SA),
    S9 \= S3,
    
    s(S9, ' '),
    ((s(S6, ' '); s(S6, x)), (s(S7, x); s(S7, ' ')), (s(S8, x); s(S8, ' ')), (s(SA, ' '); s(SA, x))),
    (s(S7, x), s(S8, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(S7, x), s(S8, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(S7, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(S7, x), s(S8, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(S7, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(S7, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S8, x),
            retract(s(S7, ' ')), assert(s(S7, x)), write([S7, 32]), nl
        );
        (
            s(S8, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S7, x),
            retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 32]), nl
        )
    ),
    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S7, _),
    o6(S7, S8, S9, S4, SA, SB),
    S9 \= S3,
    
    s(S9, ' '),
    ((s(S7, x); s(S7, ' ')), (s(S8, x); s(S8, ' ')), (s(SA, x); s(SA, ' ')), (s(SB, ' '); s(SB, x))),
    (s(SA, x), s(S8, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(SA, x), s(S8, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(SA, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(SA, x), s(S8, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(SA, x), s(S8, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(SA, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S8, x),
            retract(s(SA, ' ')), assert(s(SA, x)), write([SA, 32]), nl
        );
        (
            s(S8, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SA, x),
            retract(s(S8, ' ')), assert(s(S8, x)), write([S8, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S9, _),
    o6(S9, S4, SA, SB, SC, SD),
    S9 \= S3,
    
    s(SA, ' '),
    (s(SD, ' '); s(SD, x)), (s(SB, x); s(SB, ' ')), (s(SC, x); s(SC, ' ')), (s(S9, ' '); s(S9, x)),
    (s(SB, x); s(SC, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(SC, x), s(SB, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(SC, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(SC, x), s(SB, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(SC, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(SC, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SB, x),
            retract(s(SC, ' ')), assert(s(SC, x)), write([SC, 32]), nl
        );
        (
            s(SB, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SC, x),
            retract(s(SB, ' ')), assert(s(SB, x)), write([SB, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

tp :-
    s(S1, _), o6(S1, S2, S3, S4, S5, SZ),
    s(S4, ' '),
    (
        ((s(S2, x); s(S4, x)), (s(S1, x); s(S1, ' '))); 
        ((s(S4, x); s(S5, x)), (s(SZ, x); s(SZ, ' ')))
    ),
    (s(S2, x); s(S2, ' ')),
    (s(S3, x); s(S3, ' ')),
    (s(S4, x); s(S4, ' ')),
    (s(S5, x); s(S5, ' ')),

    s(S8, _),
    o6(S8, S9, S4, SA, SB, SC),
    S9 \= S3,
    
    s(SA, ' '),
    (s(SC, x); s(SC, ' ')), (s(SB, x); s(SB, ' ')), (s(S9, x), s(S9, ' ')), (s(S8, ' '); s(S8, x)),
    (s(SB, x); s(S9, x)),

    (
        (
            (s(S1, x); s(S1, ' ')), s(S2, ' '), s(S4, x), s(S9, x), s(SB, x),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 32]), nl
        );
        (
            (s(S1, x); s(S1, ' ')), s(S4, ' '), s(S2, x), s(S9, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S5, ' '), s(S4, x), s(S9, x), s(SB, x),
            retract(s(S5, ' ')), assert(s(S5, x)), write([S5, 32]), nl
        );
        (
            (s(SZ, x); s(SZ, ' ')), s(S4, ' '), s(S5, x), s(S9, x), s(SB, x),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 32]), nl
        );

        (
            s(S9, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(SB, x),
            retract(s(S9, ' ')), assert(s(S9, x)), write([S9, 32]), nl
        );
        (
            s(SB, ' '), ((s(S2, x); s(S4, x)); (s(S4, x); s(S5, x))), s(S9, x),
            retract(s(SB, ' ')), assert(s(SB, x)), write([SB, 32]), nl
        )
    ),

    vypis_p,
    test_v(x).

% Robíme kříže - položení čtvrtého pole, pravidlo 10

% Kříž doprava
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, x), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, ' '), s(S8, x), s(S9, ' '),
    retract(s(S7, ' ')), assert(s(S7, x)),
    write([S7, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, x), s(S8, ' '), s(S9, ' '),
    retract(s(S8, ' ')), assert(s(S8, x)),
    write([S8, 10]), nl,
    vypis_p,
    test_v(x).

% To samé, ale kříž doleva

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S7 \= S3,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S7 \= S3,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S2, ' ')), assert(s(S2, x)),
    write([S2, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S7 \= S3,
    s(S7, ' '), s(S8, x), s(S9, ' '),
    retract(s(S7, ' ')), assert(s(S7, x)),
    write([S7, 10]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S7 \= S3,
    s(S7, x), s(S8, ' '), s(S9, ' '),
    retract(s(S8, ' ')), assert(s(S8, x)),
    write([S8, 10]), nl,
    vypis_p,
    test_v(x).

% Položení L - třetí pole, pravidlo 50

tp :-
    s(S3, x),
    o3(S1, S2, S3, S4, S5),
    (s(S1, ' '); s(S1, x)), (s(S2, ' '); s(S2, x)), (s(S4, ' '); s(S4, x)), (s(S5, ' '); s(S5, x)),

    [S1X, S1Y] = S1, [S5X, S5Y] = S5, (S1X = S5X; S1Y = S5Y),
    (
        (
            S1X = S6X, S5X = SAX, 
            ((SAY is S5Y-2, S6Y is S1Y-2); (SAY is S5Y+2, S6Y is S1Y+2))
        );
        (
            S1Y = S6Y, S5Y = SAY, 
            (SAX is S5X-2, S6X is S1X-2; SAX is S5X+2, S6X is S1X+2)
        )
    ),
    S6 = [S6X, S6Y],
    SA = [SAX, SAY],

    o(S6, S7, S8, S9, SA),
    S3 \= S8, S2 \= S7,
    (s(S8, ' '); s(S8, x)),
    (s(S7, ' '); s(S7, x)),(s(S9, ' '); s(S9, x)),

    (
        (
            s(S2, x), s(S7, x), s(S3, ' '),
            retract(s(S3, ' ')), assert(s(S3, x)), write([S3, 51]), nl
        );
        (
            s(S3, x), s(S8, x), s(S6, ' '),
            retract(s(S2, ' ')), assert(s(S2, x)), write([S2, 52]), nl
        );
        (
            s(S3, x), s(S8, x), s(S9, ' '),
            retract(s(S4, ' ')), assert(s(S4, x)), write([S4, 53]), nl
        );
        (
            s(S4, x), s(S9, x), s(S3, ' '),
            retract(s(S3, ' ')), assert(s(S3, x)), write([S3, 54]), nl
        )
    ),
    vypis_p,
    test_v(x).

% Robíme kříže - položení třetího pole, pravidlo 11
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, x), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S8, ' ')), assert(s(S8, x)),
    write([S8, 11]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S8, ' ')), assert(s(S8, x)),
    write([S8, 11]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 11]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, x), s(S8, x), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 11]), nl,
    vypis_p,
    test_v(x).

% Robíme kříže - položení druhého pole, pravidlo 12

% Doprava
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S4, ' ')), assert(s(S4, x)),
    write([S4, 12]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, x), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 12]), nl,
    vypis_p,
    test_v(x).

% Doleva
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, x), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S2, ' ')), assert(s(S2, x)),
    write([S2, 12]), nl,
    vypis_p,
    test_v(x).

tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, x), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 12]), nl,
    vypis_p,
    test_v(x).

% Robíme kříže - položení prvního pole, pravidlo 13
% Doprava
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S2, S8, S9), S8 \= S3,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 13]), nl,
    vypis_p,
    test_v(x).

% Doleva
tp :-
    s(S1, ' '), o(S1, S2, S3, S4, S5),
    s(S2, ' '), s(S3, ' '), s(S4, ' '), s(S5, ' '),
    s(S6, ' '), o(S6, S7, S4, S8, S9), S8 \= S5,
    s(S7, ' '), s(S8, ' '), s(S9, ' '),
    retract(s(S3, ' ')), assert(s(S3, x)),
    write([S3, 13]), nl,
    vypis_p,
    test_v(x).































































































































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





















%tah:
%      _
%      x
%  _ x P x _
%      x
%      _

% tp :-   ss(A1, ' '), o(AID, A1, A2, C, A4, A5),
%         ss(A2, 'x'), ss(C, ' '), ss(A4, 'x'), ss(A5, ' '),
%         ss(B1, ' '), o(BID, B1, B2, C, B4, B5), AID \= BID,
%         ss(B2, 'x'), ss(B4,x), ss(B5, ' '), tah_a(S3, 'O_CEN_1', AID).






% prvně utočit.
% preferovat to, co mu ohrozí více pozic.

















































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
ss_is(X) :- ss(X, _).
ss_not(X) :- \+ ss(X, _).
