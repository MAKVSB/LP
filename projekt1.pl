% Zásobníkový automat -> 30
% Daniel Makovský -- LP -- 2025 (verze: přijetí při prázdném zásobníku)

% Přechodová pravidla: [Stav, ČtenýSymbol, VrcholZásobníku, NovýStav, AkceNaZásobník]
% eps znamená "nic", tedy vrchol se zahodí

transitions([
    [q0, a, z, q0, [a, z]],
    [q0, a, a, q0, [a, a]],
    [q0, b, a, q1, [eps]],
    [q1, b, a, q1, [eps]],
    [q1, eps, z, q2, [eps]]
]).

% Počáteční zásobník je prázdný
initial_stack([z]).

% Přijetí — pokud vstupní slovo je prázdné A zásobník je prázdný
accept(Input0, StartState) :-
    ( atom(Input0) -> atom_chars(Input0, Input) ; Input = Input0 ),
    transitions(Transitions),
    initial_stack(Stack),
    atomic_list_concat(Input, PrintInput),
    atomic_list_concat(Stack, PrintStack),
    print('Stack progression: '), nl, print(StartState), tab(1), print(PrintInput), tab(1), print(PrintStack), nl,
    run(Transitions, StartState, Input, Stack).

% Přijmout: když je vstup i zásobník prázdný
run(_, _, [], []).

% Přechod se čtením symbolu
run(Transitions, State, [Symbol | RestInput], Stack) :-
    ( Stack = [Top | RestStack] ; Stack = [], Top = eps, RestStack = [] ),
    select_transition(Transitions, State, Symbol, Top, NewState, StackAction),
    update_stack(StackAction, RestStack, NewStack),
    atomic_list_concat(RestInput, PrintInput),
    atomic_list_concat(NewStack, PrintStack),
    print(NewState), tab(1), print(PrintInput), tab(1), print(PrintStack), nl,
    run(Transitions, NewState, RestInput, NewStack).

% ε-přechod (bez čtení vstupního symbolu)
run(Transitions, State, Input, Stack) :-
    ( Stack = [Top | RestStack] ; Stack = [], Top = eps, RestStack = [] ),
    select_transition(Transitions, State, eps, Top, NewState, StackAction),
    update_stack(StackAction, RestStack, NewStack),
    atomic_list_concat(Input, PrintInput),
    atomic_list_concat(NewStack, PrintStack),
    print(NewState), tab(1), print(PrintInput), tab(1), print(PrintStack), nl,
    run(Transitions, NewState, Input, NewStack).

% Výběr přechodu
select_transition(Transitions, State, Symbol, Top, NewState, StackAction) :-
    member([State, Symbol, Top, NewState, StackAction], Transitions).

% Zásobníkové operace
update_stack([eps], Rest, Rest).
update_stack(NewSymbols, Rest, NewStack) :-
    NewSymbols \= [eps],
    append(NewSymbols, Rest, NewStack).
