secti(0,0).
secti(N,F) :- N>0, N1 is N-1, secti(N1, F1), F is F1+N.

nat(0).
nat(N) :- nat(N1), N is N1+1.

sudy(0).
sudy(N) :- sudy(N1), N is N1+2.

lichy(1).
lichy(N) :- lichy(N1), N is N1+2.