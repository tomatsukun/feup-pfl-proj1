:- consult(utils).


%celulas do board
cell([r | _], ' r ').
cell([b | _], ' b ').
cell(_, '   ').

%criar cada row do board
display_row([]) :- nl.
display_row([Cell | Rest]) :-
    cell(Cell, DisplayCell),
    write(' '),         % |_
    write(DisplayCell), % |_c
    write(' '),         % |_c_
    write('|'),         % |_c_|
    display_row(Rest).

%preencher o board
display_board([]):- write('|-----|-----|-----|-----|-----| '), nl.
display_board([Row | Rest]) :-
    write('|-----|-----|-----|-----|-----| '), nl,
    write('|'),
    display_row(Row),
    display_board(Rest), nl.

%estado inicial do board e o seu display
initial_board:-
    Board = [
        [[r], [r], [r], [r], [r]],
        [[], [], [], [], []],
        [[], [], [], [], []],
        [[], [], [], [], []],
        [[b], [b], [b], [b], [b]]
    ],
    display_board(Board).
