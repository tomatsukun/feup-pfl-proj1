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
initial_board(Board):-
    Board = [
        [[], [], [], [], []],
        [[], [], [], [], []],
        [[], [], [], [], []],
        [[], [], [], [], []],
        [[], [], [], [], []]
    ].

% Predicate to update the board at a specific Row, Column with Value
update_board(Board, Row, Column, Value, UpdatedBoard) :-
    replace(Board, Row, Column, Value, UpdatedBoard).

% Predicate to replace the value at Row, Column in the board
replace([Row|Rows], 0, Column, Value, [UpdatedRow|Rows]) :-
    replace_in_row(Row, Column, Value, UpdatedRow).

replace([Row|Rows], RowIndex, Column, Value, [Row|UpdatedRows]) :-
    RowIndex > 0,
    NewRowIndex is RowIndex - 1,
    replace(Rows, NewRowIndex, Column, Value, UpdatedRows).

% Predicate to replace the value in a specific column in a row
replace_in_row([_|Columns], 0, Value, [Value|Columns]).
replace_in_row([Column|Columns], ColumnIndex, Value, [Column|UpdatedColumns]) :-
    ColumnIndex > 0,
    NewColumnIndex is ColumnIndex - 1,
    replace_in_row(Columns, NewColumnIndex, Value, UpdatedColumns).

run(Piece, X, Y, Board, UpdatedBoard):-
    (valid_coordinates(X, Y) ->
        update_board(Board, X, Y, [Piece], UpdatedBoard),
        display_board(UpdatedBoard)
    ;   write('Invalid coordinates. Please choose within the board.'), nl, 
        UpdatedBoard = Board, % Maintain the board state if coordinates are invalid
        display_board(Board)
    ).


valid_coordinates(X, Y) :-
    X >= 0, X < 5, % Assuming a 5x5 board
    Y >= 0, Y < 5.
