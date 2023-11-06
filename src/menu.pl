% menu.pl
% Este arquivo é responsável por mostrar o menu inicial ao usuário e obter suas escolhas.



:- consult(board).

% Bibliotecas necessárias
:- use_module(library(lists)).
:- use_module(library(random)).

% --------------------- MENU PRINCIPAL ---------------------

% Mostra o menu principal e obtém a escolha do usuário.
main_menu :-
    write('|-----------------------------|'), nl,
    write('| Six MaKING - Menu Principal |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Humano vs Humano         |'), nl,
    write('| 2. Humano vs Computador     |'), nl,
    write('| 3. Computador vs Computador |'), nl,
    write('|-----------------------------|'), nl,
    write('| 4. Sair                     |'), nl,
    write('|-----------------------------|'), nl,
    write('| Escolha uma opcao: '),
    read(Option),
    process_option(Option, (8, 8)).

% Processes the user choice..
process_option(1, Counters) :- % Human vs Human
    initial_board(Board),
    clear,
    random_select(Color, [r, b], _Rest),
    choose_move(Board, Color, Counters).

process_option(2, Counters) :- % Human vs Computer
    initial_board(Board),
    clear,
    choose_bot_dif(Board, Counters).

process_option(3, Counters) :- % Computer vs Computer
    initial_board(Board),
    clear,
    random_select(Color, [r], _Rest),
    choose_bot_dif_bvb(Board, Counters, Color).

process_option(4, _). % leave

% -------------------- PLAYER -------------------------


choose_move(Board, Color, Counters):-
    (game_over(Board, Winner) ->
        write('The winner is: '),
        get_player_name(Winner, Player),
        write(Player), nl,
        write('Press Any Key to Continue'), nl,
        read(Option),
        play
    ;
        nl,
        write('|-----------------------------|'), nl,
        write('|         Choose Move         |'), nl,
        write('|-----------------------------|'), nl,
        write('| 1. Place piece              |'), nl,
        write('| 2. Move Piece               |'), nl,
        write('|-----------------------------|'), nl,
        write('| Choose an option: '), nl,
        read(Option),
        process_choose_move(Option, Board, Color, Counters)
    ).

%% Player chose to place a piece
process_choose_move(1, Board, Color, Counters):-
    clear,
    place_piece(Counters, Board, Color).

%% Player chose to move a already existing piece
process_choose_move(2, Board, Color, Counters):-
    move_piece(Board, Color, Counters).

move_piece(Board, Color, Counters):-
    write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, Color, NewColor, UpdatedBoard), nl,
                choose_move(UpdatedBoard, NewColor, Counters)
            ; 
                choose_move(Board, Color, Counters)
            )
        ;
            write('Must be an occupied cell. Please, try again.'), nl,
            choose_move(Board, Color, Counters)
        );
        write('No piece found at the specified current position.'), nl, 
        choose_move(Board, Color, Counters)
    ).

% Player r has pieces left
hasPiecesLeft((CounterR, _CounterB), r):-
    CounterR > 0.

% Player b has pieces left
hasPiecesLeft((_CounterR, CounterB), b):-
    CounterB > 0.

%% Place piece 
place_piece((0, CounterB), Board, r) :-
    nl,
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_game((Board, r)),
    choose_move(Board, r, (0, CounterB)).

place_piece((CounterR, 0), Board, b) :-
    nl,
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_game((Board, b)),
    choose_move(Board, b, (CounterR, 0)).

place_piece(Counters, Board, Color):-
    hasPiecesLeft(Counters, Color),
    write('|-----------------------------|'), nl,
    write('|    Choose Where to place    |'), nl,
    write('|-----------------------------|'), nl,
    write('| X-Y of the piece |'), nl,
    read(X-Y),
    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,
    insert_piece(Color, X, Y, Board, UpdatedBoard, Counters, NewCounters, NewColor),
    choose_move(UpdatedBoard, NewColor, NewCounters).
  
%% Move piece 
move_piece:-
  write('|-----------------------------|'), nl,
  write('|    Choose Piece to Move     |'), nl,
  write('|-----------------------------|'), nl,
  write('| X of the piece |'), nl,
  read(X_old),
  write('| Y of the piece |'), nl,
  read(Y_old),
  write('|-----------------------------|'), nl,
  write('|    Choose Where to Move     |'), nl,
  write('|-----------------------------|'), nl,
  write('| New X of the piece |'), nl,
  read(X_new),
  write('| New Y of the piece |'), nl,
  read(Y_new),
  process_move_piece(X_old-Y_old, X_new-Y_new ).

process_move_piece(X_old-Y_old, X_new-Y_new ):-
  write('| Old X = |'), write(X_old),nl,
  write('| New X = |'), write(X_new),nl,
  write('| Old Y = |'), write(Y_old),nl,
  write('| New Y = |'), write(Y_new).

% ------------------PLAYER vs COMPUTER ------------------

% Chooses bot difficulty
choose_bot_dif(Board, Counters):-
    write('|-----------------------------|'), nl,
    write('|    Choose Bot Difficulty    |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Easy                     |'), nl,
    write('| 2. Hard                     |'), nl,
    write('|-----------------------------|'), nl,
    write('| Escolha uma opcao: '),
    read(Option),
    process_choose_bot_dif(Option, Board, Counters).

% Processes the choice of bot difficulty
process_choose_bot_dif(1, Board, Counters):-
     (game_over(Board, Winner) ->
        write('The winner is: '),
        write(Winner), nl,
        write('Press Any Key to Continue'), nl,
        read(Option),
        play
    ;
        write('|-----------------------------|'), nl,
        write('|         Choose Move         |'), nl,
        write('|-----------------------------|'), nl,
        write('| 1. Place piece              |'), nl,
        write('| 2. Move Piece               |'), nl,
        write('|-----------------------------|'), nl,
        write('| Choose an option: '),
        read(Option),nl,
        process_choose_move_vsbot(Option, Board, _Color, Counters)
    ). 
    

%% Player chose to place a piece
process_choose_move_vsbot(1, Board, Color, Counters):-
    write('     0     1     2     3     4'), nl,
    display_board(Board,0),nl,
    place_piece_pvsbot(Counters, Board, Color).

%% Player chose to move a piece
process_choose_move_vsbot(2, Board, Color, Counters):-
    move_piece_pvsbot(Board, Color, Counters).

% Place piece vs Bot
place_piece_pvsbot((0, _CounterB), Board, r) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    process_choose_bot_dif(1, (0,_CounterB),Board).

place_piece_pvsbot((_CounterR, 0), Board, b) :-
    write('|-----------------------------|'), nl,
    write('| Computer placed all pieces! |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    process_choose_bot_dif(1, (_CounterR,0),Board).

place_piece_pvsbot(Counters, Board, Color):-
    hasPiecesLeft(Counters, Color),
    write('|-----------------------------|'), nl,
    write('|    Choose Where to place    |'), nl,
    write('|-----------------------------|'), nl,
    write('| X-Y of the piece |'), nl,
    read(X-Y),
    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,
    insert_piece_pvsbot(r, X, Y, Board, UpdatedBoard, Counters, NewCounters, NewColor), % Player places piece
    random(1, 6, RandNumber), % Bot choses between placing or moving a piece with a chance of behing move 20%
    ( RandNumber = 2 -> 
        move_piece_bot(NewCounters, UpdatedBoard,  NewColor)
      ; 
        place_piece_bot(NewCounters, UpdatedBoard, NewColor)    
    ).

% Moves piece Player vs Bot
move_piece_pvsbot(Board, Color, Counters):-
write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, Color, NewColor, UpdatedBoard), nl,
                place_piece_bot(Counters,UpdatedBoard, NewColor)
            ; 
                process_choose_bot_dif(1, Board, Counters)
            )
        ;
            write('Must be an occupied cell. Please, try again.'), nl,
            process_choose_bot_dif(1, Board, Counters)
        );
        write('No piece found at the specified current position.'), nl, 
        process_choose_bot_dif(1, Board, Counters)
    ).

% Places bot piece
place_piece_bot(Counters, Board, Color):-
    hasPiecesLeft(Counters, Color),
    random_XY_generator(Rand_X,Rand_Y),
    run_bot(Color, Rand_X, Rand_Y, Board, UpdatedBoard, Counters, NewCounters, _NewColor),
    process_choose_bot_dif(1, UpdatedBoard, NewCounters).

% Moves bot piece
move_piece_bot((NewCounterR, NewCounterB), Board, Color):-
  ( NewCounterB = 8 -> %% Forces the bot to always place a piece on the first move
      place_piece_bot((NewCounterR, NewCounterB), Board, Color)
  ; 
    (NewCounterB < 3 -> %% To prevent the program from running for a long time, the bot will only start moving pieces when there are at least 10 pieces on the board
    random_XY_generator(CurrentX, CurrentY),
     (check_piece(Board, CurrentX, CurrentY) ->
       get_length(Board, CurrentX, CurrentY, Length),
        (check_piece(Board, NewX, NewY) -> 
          (validate_move_bot(CurrentX, CurrentY, NewX, NewY, Length) -> 
              move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, b, _NewColor, UpdatedBoard), 
              switch_color(Color, _NewColor),
              write('Bot moved the piece at ('),
              write(CurrentX),write('-'),write(CurrentY),
              write(') to '),
              write('('),
              write(NewX),write('-'),write(NewY),
              write(')'),nl,
              write('Chega aqui!'),
              %process_choose_bot_dif(1, UpdatedBoard, NewCounters)
              process_choose_bot_dif(1, UpdatedBoard, (NewCounterR, NewCounterB))
          ;
          move_piece_bot((NewCounterR, NewCounterB), Board, Color)          
          )
        ;
        move_piece_bot((NewCounterR, NewCounterB), Board, Color)
        )
    ;
      move_piece_bot((NewCounterR, NewCounterB), Board, Color)
    )
    ;
      place_piece_bot((NewCounterR, NewCounterB), Board, Color)
    )
  ).
      
% --------------------- Computer vs Computer ---------------------

% Choses Bot difficulty in Bot vs Bot
choose_bot_dif_bvb(Board, Counters, Color):-
    write('|-----------------------------|'), nl,
    write('|    Choose Bot Difficulty    |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Easy                     |'), nl,
    write('| 2. Hard                     |'), nl,
    write('|-----------------------------|'), nl,
    write('| Escolha uma opcao: '),
    read(Option),
    process_choose_bot_dif_bvb(Option, Board, Counters, Color).

% Processes Bot difficulty in Bot vs Bot
process_choose_bot_dif_bvb(1, Board, Counters, Color):-
  (game_over(Board, Winner) ->
        write('The winner is: '),
        write(Winner), nl,
        write('Press Any Key to Continue'), nl,
        read(_Option),
        play
    ;
      place_piece_bot_bvb(Counters, Board, Color)
    ). 

% Places piece in Bot vs Bot
place_piece_bot_bvb(Counters, Board, Color):-
    hasPiecesLeft(Counters, Color),
    random_XY_generator(Rand_X,Rand_Y),
    run_bot(Color, Rand_X, Rand_Y, Board, UpdatedBoard, Counters, NewCounters, NewColor),
    process_choose_bot_dif_bvb(1, UpdatedBoard, NewCounters, NewColor).