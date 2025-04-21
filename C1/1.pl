%pohlavi
zena(pavla).
zena(jana).
zena(eva).
zena(andrea).
zena(tereza).

muz(marek).
muz(tomas).
muz(cyril).
muz(fero).
muz(jozko).

rodic(marek,eva).
rodic(pavla,eva).
rodic(marek,cyril).
rodic(pavla,cyril).

rodic(tereza,andrea).
rodic(jana,andrea).
rodic(tereza,refo).
rodic(jana,fero).

rodic(cyril, jozo).
rodic(andrea, jozo).
rodic(cyril, tereza).
rodic(andrea, tereza).

matka(X,Y) :- zena(X),rodic(X,Y).
otec(X,Y) :- not(zena(X)), rodic(X,Y).
babicka(X,Y) :- matka(X,Z),rodic(Z,Y).
bratr(X,Y) :- muz(X), rodic(Z,X),!, rodic(Z,Y), X\=Y.
