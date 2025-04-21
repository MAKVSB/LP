cisla(X,X,[X]) :- !.
cisla(A,X,[A|R]) :- A<X, A1 is A+1, cisla(A1, X, R).

generuj1(_, []).
generuj1(X, [Y|LY]) :- assert(ss([X,Y],' ')), generuj1(X, LY).

generuj([], _).
generuj([X|LX], LY) :- generuj1(X, LY), generuj(LX, LY).

pole(MAXX, MAXY) :- cisla(0, MAXX, LX), cisla(0, MAXY, LY), generuj(LX,LY).

prepare :- pole(9,9), v_pole.
cleanup :- retract(ss(_, _)), fail.
reset :- cleanup, prepare.


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
v_radek_label_part(X, Y) :-  write(X), write("   "), X1 is X+1, v_radek_label_part(X1, Y).
v_radek_label :- write("    "), v_radek_label_part(0, 10).




o(1, [X,Y], [X1, Y], [X2, Y], [X3,Y], [X4,Y]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4.
o(2, [X,Y], [X, Y1], [X, Y2], [X,Y3], [X,Y4]) :- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.
o(3, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4.
o(4, [X,Y], [X1, Y1],  [X2, Y2], [X3, Y3], [X4, Y4]) :- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4,
                                                        Y1 is Y-1, Y2 is Y-2, Y3 is Y-3, Y4 is Y-4.

% tah hráče o
tah(X,Y) :- ss([X,Y],' '), retract(ss([X,Y],' ')), assert(ss([X,Y], 'o')), nl, v_pole, test_v(o).

% test vítězství. H = symbol hráče (o/x)
test_v(H) :-    ss(S1,H), o(_,S1,S2,S3,S4,S5),
                ss(S2, H), ss(S3, H), ss(S4, H), ss(S5, H),
                nl, write("Vítěz: "), write(H), write(" : "), write([S1, S2, S3, S4, S5]).
test_v(_).

tah_p([X,Y], RULE) :- retract(ss([X,Y],' ')), assert(ss([X,Y], 'x')), v_pole, nl, write("Tah "), write(RULE), write(": ["), write(X), write(","), write(Y), write("]"), test_v(x).


tah_p_random :- ss(S, ' '),
                retract(ss(S,' ')),
                assert(ss(S,x)),
                v_pole, nl, write("Náhodný tah: "), write(S),
                test_v(x).


% pravidla


% doplnění do pětice
tp :- ss(S1, x), o(_, S1, S2, S3, S4, S5), tah_p(S1, "O_DOP_1"), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x').
tp :- ss(S1, x), o(_, S1, S2, S3, S4, S5), ss(S1, 'x'), tah_p(S2, "O_DOP_2"), ss(S3, 'x'), ss(S4, 'x'), ss(S5, 'x').
tp :- ss(S1, x), o(_, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), tah_p(S3, "O_DOP_3"), ss(S4, 'x'), ss(S5, 'x').
tp :- ss(S1, x), o(_, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), tah_p(S4, "O_DOP_4"), ss(S5, 'x').
tp :- ss(S1, x), o(_, S1, S2, S3, S4, S5), ss(S1, 'x'), ss(S2, 'x'), ss(S3, 'x'), ss(S4, 'x'), tah_p(S5, "O_DOP_5").

%tah:
%           
%      x
%  _ x V x
%      x
%      _ 
tp :-   ss(A1, ' '), o(AID, A1, A2, C, A4, A5),
        ss(A2, x), ss(C, ' '), ss(A4, x), ss(A5, ' '),
        ss(B1, ' '), o(BID, B1, B2, C, B4, B5), AID \= BID, 
        ss(B2, x), ss(B4,x), ss(B5, ' '), tah_p(S3, "O_CEN_1").  

%tah:
%    o
%  o V o
%    o
tp :-   ss(A1, ' '), o(AID, A1, A2, C, A4, A5),
        ss(A2, o), ss(C, ' '), ss(A4, o), ss(A5, ' '),
        ss(B1, ' '), o(BID, B1, B2, C, B4, B5), AID \= BID, 
        ss(B2, o), ss(B4,o), ss(B5, ' '), tah_p(S3, "D_CEN_1").  


















tp :- tah_p_random.








% prvně utočit.
% preferovat to, co mu ohrozí více pozic.

























ss([4,4], '').
ss([5,4], '').
ss([5,5], '').
ss([4,5], '').

ss([3,5], '').
ss([3,4], '').
ss([3,3], '').
ss([4,3], '').
ss([5,3], '').
ss([6,3], '').
ss([6,4], '').
ss([6,5], '').
ss([6,6], '').
ss([5,6], '').
ss([4,6], '').
ss([3,6], '').

ss([2,6], '').
ss([2,5], '').
ss([2,4], '').
ss([2,3], '').
ss([2,2], '').
ss([3,2], '').
ss([4,2], '').
ss([5,2], '').
ss([6,2], '').
ss([7,2], '').
ss([7,3], '').
ss([7,4], '').
ss([7,5], '').
ss([7,6], '').
ss([7,7], '').
ss([6,7], '').
ss([5,7], '').
ss([4,7], '').
ss([3,7], '').
ss([2,7], '').

ss([1,7], '').
ss([1,6], '').
ss([1,5], '').
ss([1,4], '').
ss([1,3], '').
ss([1,2], '').
ss([1,1], '').
ss([2,1], '').
ss([3,1], '').
ss([4,1], '').
ss([5,1], '').
ss([6,1], '').
ss([7,1], '').
ss([8,1], '').
ss([8,2], '').
ss([8,3], '').
ss([8,4], '').
ss([8,5], '').
ss([8,6], '').
ss([8,7], '').
ss([8,8], '').
ss([7,8], '').
ss([6,8], '').
ss([5,8], '').
ss([4,8], '').
ss([3,8], '').
ss([2,8], '').
ss([1,8], '').

ss([0,8], '').
ss([0,7], '').
ss([0,6], '').
ss([0,5], '').
ss([0,4], '').
ss([0,3], '').
ss([0,2], '').
ss([0,1], '').
ss([0,0], '').
ss([1,0], '').
ss([2,0], '').
ss([3,0], '').
ss([4,0], '').
ss([5,0], '').
ss([6,0], '').
ss([7,0], '').
ss([8,0], '').
ss([9,0], '').
ss([9,1], '').
ss([9,2], '').
ss([9,3], '').
ss([9,4], '').
ss([9,5], '').
ss([9,6], '').
ss([9,7], '').
ss([9,8], '').
ss([9,9], '').
ss([8,9], '').
ss([7,9], '').
ss([6,9], '').
ss([5,9], '').
ss([4,9], '').
ss([3,9], '').
ss([2,9], '').
ss([1,9], '').
ss([0,9], '').