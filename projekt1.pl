% Zásobníkový automat -> 30

% MS = Množina stavů
% PS = Počáteční stav
% ZOB = Množina zobrazení
% ZOB ve tvaru [(znak, ze stavu, do stavu, přidat/odebrat, znak na zásobník),....]

ms :- ['A', 'B', 'C'].
ps :- 
zob :- [
    ('1', 'A', 'B', '+', '1'),
    ('2', 'B', 'A', '-', '1'),
]

za(PS, ZOB) :- 
