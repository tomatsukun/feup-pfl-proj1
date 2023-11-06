:- consult(utils).


%celulas do board


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
    display_board(Rest, NewIndex).

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
replace_in_row([Column|Columns], 0, Value, [[Value | Column]|Columns]).
replace_in_row([Column|Columns], ColumnIndex, Value, [Column|UpdatedColumns]) :-
    ColumnIndex > 0,
    NewColumnIndex is ColumnIndex - 1,
    replace_in_row(Columns, NewColumnIndex, Value, UpdatedColumns).



% Predicate to update the board at a specific Row, Column with Value
remove_from_stack(Board, Row, Column, Piece, UpdatedBoard) :-
    find_row_remove(Board, Row, Column, Piece, UpdatedBoard).

% Predicate to replace the value at Row, Column in the board
find_row_remove([Row|Rows], 0, Column, Piece, [UpdatedRow|Rows]) :-
    find_col_remove(Row, Column, Piece, UpdatedRow).

find_row_remove([Row|Rows], RowIndex, Column, Piece, [Row|UpdatedRows]) :-
    RowIndex > 0,
    NewRowIndex is RowIndex - 1,
    find_row_remove(Rows, NewRowIndex, Column, Piece, UpdatedRows).

% Predicate to replace the value in a specific column in a row
find_col_remove([[Piece | Rest] |Columns], 0, Piece, [Rest | Columns]).
find_col_remove([Column|Columns], ColumnIndex, Piece, [Column|UpdatedColumns]) :-
    ColumnIndex > 0,
    NewColumnIndex is ColumnIndex - 1,
    find_col_remove(Columns, NewColumnIndex, Piece, UpdatedColumns).


% ( condition -> then_clause ; else_clause )
%% run for bot
run_bot(b, X, Y, Board, UpdatedBoard, (CounterR, CounterB), (NewCounterR, NewCounterB), NewColor):-
  ( \+check_piece(Board, X, Y) ->
      update_board(Board, X, Y, b, UpdatedBoard),

      write('Bot placed new piece  '),
      write('('),
      write(X), write(','), write(Y),
      write(')'), nl,
      
      write('     0     1     2     3     4'), nl, 
      display_board(UpdatedBoard, 0),
      NewCounterB is CounterB - 1,
      NewCounterR = CounterR,
      switch_color(b, NewColor)
  ; 
  %% if already existes a piece in that position
      new_XY_run_bot(b, X, Y, Board, UpdatedBoard, (CounterR, CounterB), (NewCounterR, NewCounterB), NewColor)
  ).
    



new_XY_run_bot(b, X, Y, Board, UpdatedBoard, Counters, NewCounters, NewColor):-
  random_XY_generator(Rand_X,Rand_Y),
  run_bot(b, Rand_X, Rand_Y, Board, UpdatedBoard, Counters, NewCounters, NewColor).


random_XY_generator(Rand_X,Rand_Y):-
    random(0, 5, Rand_X),
    random(0, 5, Rand_Y).




insert_piece(r, X, Y, Board, UpdatedBoard, (CounterR, CounterB), (NewCounterR, NewCounterB), NewColor):-
    (valid_coordinates(X, Y) ->
        (check_piece(Board, X, Y) ->
            write('Already occupied. Choose another cell.'), nl,
            UpdatedBoard = Board,
            write('     0     1     2     3     4'), nl, 
            display_board(Board, 0),
            NewCounterR = CounterR,
            NewCounterB = CounterB,
            NewColor = r
        ; 
            update_board(Board, X, Y, r, UpdatedBoard),
            write('     0     1     2     3     4'), nl, 
            display_board(UpdatedBoard, 0),
            NewCounterR is CounterR - 1,
            NewCounterB = CounterB,
            switch_color(r, NewColor)
        );
        write('Invalid coordinates. Please choose within the board.'), nl, 
        UpdatedBoard = Board, % Maintain the board state if coordinates are invalid
        write('     0     1     2     3     4'), nl, 
        display_board(Board, 0),
        NewCounterR = CounterR,
        NewCounterB = CounterB,
        NewColor = r
    ).

insert_piece(b, X, Y, Board, UpdatedBoard, (CounterR, CounterB), (NewCounterR, NewCounterB), NewColor):-
    (valid_coordinates(X, Y) ->
        (check_piece(Board, X, Y) ->
            write('Already occupied. Choose another cell.'), nl,
            UpdatedBoard = Board,
            write('     0     1     2     3     4'), nl, 
            display_board(Board, 0),
            NewCounterB = CounterB,
            NewCounterR = CounterR,
            NewColor = b
        ; 
            update_board(Board, X, Y, b, UpdatedBoard),
            write('     0     1     2     3     4'), nl, 
            display_board(UpdatedBoard, 0),
            NewCounterB is CounterB - 1,
            NewCounterR = CounterR,
            switch_color(b, NewColor)
        );
        write('Invalid coordinates. Please choose within the board.'), nl, 
        UpdatedBoard = Board, % Maintain the board state if coordinates are invalid
        write('     0     1     2     3     4'), nl, 
        display_board(Board, 0),
        NewCounterB = CounterB,
        NewCounterR = CounterR,
        NewColor = b
    ).

valid_coordinates(X, Y) :-
    X >= 0, X < 5, % Assuming a 5x5 board
    Y >= 0, Y < 5.

check_piece(Board, X, Y) :-
    nth0(X, Board, Row),          % Get the X-th row
    nth0(Y, Row, Cell),           % Get the Y-th element in that row
    Cell \= [].                   % Check if the cell is not empty


move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, UpdatedBoard) :-
    remove_from_stack(Board, CurrentX, CurrentY, Piece, TempBoard),
    update_board(TempBoard, NewX, NewY, Piece, UpdatedBoard),
    write('     0     1     2     3     4'), nl,
    display_board(UpdatedBoard, 0).
    
get_length(Board, CurrentX, CurrentY, Length):-
    nth0(CurrentX, Board, Row),          % Get the X-th row
    nth0(CurrentY, Row, Cell),           % Get the Y-th element in that row
    length(Cell, Length).

% mudar de jogador r e b 

switch_color(r, b).
switch_color(b, r).    


