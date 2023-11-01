:- consult(utils).


%celulas do board
cell([r | _], ' r ').
cell([b | _], ' b ').
cell(_, '   ').

choose_cell([r | _], 1, ' P ').
choose_cell([r | _], 2, ' R ').
choose_cell([r | _], 3, ' L ').
choose_cell([r | _], 4, ' B ').
choose_cell([r | _], 5, ' Q ').
choose_cell([r | _], 6, ' K ').

choose_cell([b | _], 1, ' 1 ').
choose_cell([b | _], 2, ' 2 ').
choose_cell([b | _], 3, ' 3 ').
choose_cell([b | _], 4, ' 4 ').
choose_cell([b | _], 5, ' 5 ').
choose_cell([b | _], 6, ' 6 ').

choose_cell(_, 0, '   ').


%criar cada row do board
display_row([]) :- nl.
display_row([Cell | Rest]) :-
    length(Cell, Length),
    choose_cell(Cell, Length, DisplayCell),
    write(' '),         % |_
    write(DisplayCell), % |_c
    write(' '),         % |_c_
    write('|'),         % |_c_|
    display_row(Rest).

%preencher o board
display_board([], _):- write('  |-----|-----|-----|-----|-----| '), nl.
display_board([Row | Rest], Index) :-
    write('  |-----|-----|-----|-----|-----| '), nl,
    write(Index),
    write(' |'),
    display_row(Row),
    NewIndex is Index + 1,
    display_board(Rest, NewIndex), nl.

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

run(Piece, X, Y, Board, UpdatedBoard, Counter, NewCounter):-
    (valid_coordinates(X, Y) ->
        update_board(Board, X, Y, [Piece], UpdatedBoard),
        write('     0     1     2     3     4'), nl, 
        display_board(UpdatedBoard, 0),
        NewCounter is Counter - 1
    ;   write('Invalid coordinates. Please choose within the board.'), nl, 
        UpdatedBoard = Board, % Maintain the board state if coordinates are invalid
        write('     0     1     2     3     4'), nl, 
        display_board(Board, 0),
        NewCounter = Counter
    ).


valid_coordinates(X, Y) :-
    X >= 0, X < 5, % Assuming a 5x5 board
    Y >= 0, Y < 5.

check_piece(Board, X, Y) :-
    nth0(X, Board, Row),          % Get the X-th row
    nth0(Y, Row, Cell),           % Get the Y-th element in that row
    Cell \= [].                   % Check if the cell is not empty


move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, Piece, UpdatedBoard) :-
    update_board(Board, CurrentX, CurrentY, [], TempBoard),
    update_board(TempBoard, NewX, NewY, [Piece], UpdatedBoard),
    display_board(UpdatedBoard, 0).
