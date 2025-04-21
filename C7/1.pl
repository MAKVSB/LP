
start :-
    write('Zadej slovo: '), nl,
    read(WO),
    atom_chars(WO, CH),
    chars_to_ascii(CH, AL),
    write('hodnoty: '), write(AL), nl,
    remove_even(AL, FIL),
    write('hodnoty bez sudých: '), write(FIL), nl,
    ascii_to_chars(FIL, FC),
    atom_chars(FW, FC),
    write('Výsledek: '), write(FW), nl.

chars_to_ascii([], []).
chars_to_ascii([Char|Rest], [Code|Codes]) :-
    char_code(Char, Code),
    chars_to_ascii(Rest, Codes).

remove_even([], []).
remove_even([H|T], Result) :-
    0 is H mod 2, !,
    remove_even(T, Result).
remove_even([H|T], [H|Result]) :-
    remove_even(T, Result).

ascii_to_chars([], []).
ascii_to_chars([Code|Rest], [Char|CH]) :-
    char_code(Char, Code),
    ascii_to_chars(Rest, CH).
