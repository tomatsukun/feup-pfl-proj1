:- consult(utils).
:- consult(board).

% Pawn movement

% Check if the move is horizontal (same row) and only moves 1 cell
% valid_horizontal_move_P(+CurrentX, +NewX, +CurrentY, +NewY)
valid_horizontal_move_P(CurrentX, NewX, CurrentY, NewY) :-
    CurrentX =:= NewX,                   % Same row
    abs(NewY - CurrentY) =:= 1.          % Move only one cell in the row

% Check if the move is vertical (same column) and only moves 1 cell
% valid_vertical_move_P(+CurrentX, +NewX, +CurrentY, +NewY)
valid_vertical_move_P(CurrentX, NewX, CurrentY, NewY) :-
    CurrentY =:= NewY,                   % Same column
    abs(NewX - CurrentX) =:= 1.          % Move only one cell in the column

% Ensure the move is either horizontal or vertical in Pawn
% valid_horizontal_or_vertical_move_P(+CurrentX, +NewX, +CurrentY, +NewY)
valid_horizontal_or_vertical_move_P(CurrentX, NewX, CurrentY, NewY) :-
    valid_horizontal_move_P(CurrentX, NewX, CurrentY, NewY);
    valid_vertical_move_P(CurrentX, NewX, CurrentY, NewY).

% Rook movement

% Check if the move is horizontal (same row)
% valid_horizontal_move_R(+CurrentX, +NewX)
valid_horizontal_move_R(CurrentX, NewX) :-
    CurrentX =:= NewX,                   % Same row
    NewX >= 0, NewX < 5.

% Check if the move is vertical (same column)
% valid_vertical_move_R(+CurrentY, +NewY)
valid_vertical_move_R(CurrentY, NewY) :-
    CurrentY =:= NewY,                   % Same column
    NewY >= 0, NewY < 5.

% Ensure the move is either horizontal or vertical
% valid_horizontal_or_vertical_move_R(+CurrentX, +NewX, +CurrentY, +NewY)
valid_horizontal_or_vertical_move_R(CurrentX, NewX, CurrentY, NewY) :-
    valid_horizontal_move_R(CurrentX, NewX);
    valid_vertical_move_R(CurrentY, NewY).

% Knight movement
% check if move is done with 2 cells orthogonally and 1 cell diagonally
% valid_knight_move_1(+CurrentX, +NewX, +CurrentY, +NewY)
valid_knight_move_1(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewY - CurrentY) =:= 2,          
    abs(NewX - CurrentX) =:= 1.          

% valid_knight_move_2(+CurrentX, +NewX, +CurrentY, +NewY)
valid_knight_move_2(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewY - CurrentY) =:= 1,          
    abs(NewX - CurrentX) =:= 2.          

% valides movement in L shape
% valid_knight_move(+CurrentX, +NewX, +CurrentY, +NewY)
valid_knight_move(CurrentX, NewX, CurrentY, NewY):-
    valid_knight_move_1(CurrentX, NewX, CurrentY, NewY);
    valid_knight_move_2(CurrentX, NewX, CurrentY, NewY).

% Bishop movement

% checks if the move is made with coordinates X and Y with same values
% valid_bishop_move(+CurrentX, +NewX, +CurrentY, +NewY)
valid_bishop_move(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewX - CurrentX) =:= abs(NewY - CurrentY).




% validates all moves

% validate_move(+CurrentX, +CurrentY, +NewX, +NewY, +LengthStack)
validate_move(CurrentX, CurrentY, NewX, NewY, 1):-
    (valid_horizontal_or_vertical_move_P(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Pawn can only move in horizontal or vertical moves and one cell. Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 2):-
    (valid_horizontal_or_vertical_move_R(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Rook can only move in horizontal or vertical moves. Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 3):-
    (valid_knight_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Knight can only move in L shape (1 step orthogonal and then 1 step diagonal). Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 4):-
    (valid_bishop_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Bishop only moves diagonally. Try again.'),
        false
    ).

validate_move(_CurrentX, _CurrentY, _NewX, _NewY, 5):-
    true.

%validate moove bot

validate_move_bot(CurrentX, CurrentY, NewX, NewY, 1):-
    (valid_horizontal_or_vertical_move_P(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        
        false
    ).

validate_move_bot(CurrentX, CurrentY, NewX, NewY, 2):-
    (valid_horizontal_or_vertical_move_R(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        
        false
    ).

validate_move_bot(CurrentX, CurrentY, NewX, NewY, 3):-
    (valid_knight_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        
        false
    ).

validate_move_bot(CurrentX, CurrentY, NewX, NewY, 4):-
    (valid_bishop_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        
        false
    ).

validate_move_bot(_CurrentX, _CurrentY, _NewX, _NewY, 5):-
    true.




% trocar de jogador
% next_player(+Player, +Player, +TypeGame)
next_player(player, player, player-player).
next_player(player, bot, player-bot).
next_player(bot, player, player-bot).
next_player(botF, botD, botF-botD).
next_player(botD, botF, botF-botD).


% checks if the game has ended
% game_over(+Board, -Winner)
game_over(Board, Winner) :-
    member(Rows, Board),
    member(Stack, Rows),
    length(Stack, 6),
    Stack = [Winner | _].
