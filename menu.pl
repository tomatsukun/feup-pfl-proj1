% menu.pl
% Este arquivo é responsável por mostrar o menu inicial ao usuário e obter suas escolhas.





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
    process_option(Option, 8, 8).



% Processa a escolha do usuário.
process_option(1, CounterR, CounterB) :- % Humano vs Humano
    initial_board(Board),
    clear,
    random_select(Color, [r, b], _Rest),
    choose_move((Board, Color), CounterR, CounterB).

process_option(2, CounterR, CounterB) :- % Humano vs Computador
    initial_board(Board),
    clear,
    choose_bot_dif(Board).
    
choose_bot_dif(Board):-
    write('|-----------------------------|'), nl,
    write('|    Choose Bot Difficulty    |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Easy                     |'), nl,
    write('| 2. Hard                     |'), nl,
    write('|-----------------------------|'), nl,
    write('| Escolha uma opcao: '),
    read(Option),
    process_choose_bot_dif(Option, 8, 8, Board).

process_choose_bot_dif(1, CounterR, CounterB, Board):-
    %random(1, 3, RandNumber), % escolhe random se vai mover ou clocar nova peça
    random_select(Color, [r,b], _Rest),
     (check_six_maKING(Board, Winner) ->
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
        write('| Choose an option: '), nl,
        read(Option),
        %clear,
        process_choose_move_vsbot(Option, (Board, Color), CounterR, CounterB)
    ), % turno do player
    write('Chega aqui'),nl,
    ( 1 = 1 ->  
    write('Bot placed a Piece!'),nl ; write('Bot moves piece'),nl ).
    
%% Player chose to place a piece
process_choose_move_vsbot(1, (Board, Color), CounterR, CounterB):-
    clear,
    place_piece_pvsbot(CounterR, CounterB, Board, Color).

%% Player chose to move a piece
process_choose_move_vsbot(2, (Board, Color), CounterR, CounterB):-
    clear,
    process_choose_move(2, (Board, Color), CounterR, CounterB).

place_piece_pvsbot(0, CounterB, Board, r) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0).
    %%choose_move((Board, r), 0, CounterB).


place_piece_pvsbot(CounterR, 0, Board, b) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0).
    %%choose_move((Board, b), CounterR, 0).

place_piece_pvsbot(CounterR, CounterB, Board, Color):-
    hasPiecesLeft(CounterR, CounterB, Color),
    write('|-----------------------------|'), nl,
    write('|    Choose Where to place    |'), nl,
    write('|-----------------------------|'), nl,
    write('| X-Y of the piece |'), nl,
    read(X-Y),

    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,

    run(r, X, Y, Board, UpdatedBoard, CounterR, CounterB, NewCounterR, NewCounterB, NewColor),
    place_piece_bot(NewCounterR, NewCounterB, UpdatedBoard, NewColor).


place_piece_bot(CounterR, CounterB, Board, Color):-
    hasPiecesLeft(CounterR, CounterB, Color),
    random(0, 5, Rand_X),
    random(0, 5, Rand_Y),
    write('Bot placed new piece  '),
    write('('),
    write(Rand_X), write(','), write(Rand_Y),
    write(')'), nl,

    run_bot(b, 0, 0, Board, UpdatedBoard, CounterR, CounterB, NewCounterR, NewCounterB, NewColor),
    process_choose_bot_dif(1, CounterR, CounterB, UpdatedBoard).

%% Bot chose to move a already existing piece
process_choose_move_bot(2, (Board, Color), CounterR, CounterB):-
    nl,
    write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, r, UpdatedBoard), nl, nl, 
                switch_color(Color, NewColor),
                choose_move((UpdatedBoard, NewColor), CounterR, CounterB)
            ; 
                process_choose_move(2, (Board, Color), CounterR, CounterB)
            )
        ;
            write('Must be an occupied cell. Please, try again.'), nl, nl, 
            process_choose_move(2, (Board, Color), CounterR, CounterB)
        );
        write('No piece found at the specified current position.'), nl, nl, 
        process_choose_move(2, (Board, Color), CounterR, CounterB)
    ).



  
continues(NewCounter, Board):-
    write('Do you want to place another piece? (yes/no)'), nl,
    read(Answer),
    (Answer = yes -> place_piece(NewCounter, Board); true).


choose_move((Board, Color), CounterR, CounterB):-
    (check_six_maKING(Board, Winner) ->
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
        write('| Choose an option: '), nl,
        read(Option),
        process_choose_move(Option, (Board, Color), CounterR, CounterB)
    ).



%% Player chose to place a piece
process_choose_move(1, (Board, Color), CounterR, CounterB):-
    clear,
    place_piece(CounterR, CounterB, Board, Color).

%% Player chose to move a already existing piece
process_choose_move(2, (Board, Color), CounterR, CounterB):-
    nl,
    write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, r, UpdatedBoard), nl, nl, 
                switch_color(Color, NewColor),
                choose_move((UpdatedBoard, NewColor), CounterR, CounterB)
            ; 
                process_choose_move(2, (Board, Color), CounterR, CounterB)
            )
        ;
            write('Must be an occupied cell. Please, try again.'), nl, nl, 
            process_choose_move(2, (Board, Color), CounterR, CounterB)
        );
        write('No piece found at the specified current position.'), nl, nl, 
        process_choose_move(2, (Board, Color), CounterR, CounterB)
    ).


%% Place piece 
place_piece(0, CounterB, Board, r) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    choose_move((Board, r), 0, CounterB).


place_piece(CounterR, 0, Board, b) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    choose_move((Board, b), CounterR, 0).

hasPiecesLeft(CounterR, CounterB, r):-
    CounterR > 0.

hasPiecesLeft(CounterR, CounterB, b):-
    CounterB > 0.

place_piece(CounterR, CounterB, Board, Color):-
    hasPiecesLeft(CounterR, CounterB, Color),
    write('|-----------------------------|'), nl,
    write('|    Choose Where to place    |'), nl,
    write('|-----------------------------|'), nl,
    write('| X-Y of the piece |'), nl,
    read(X-Y),

    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,

    run(Color, X, Y, Board, UpdatedBoard, CounterR, CounterB, NewCounterR, NewCounterB, NewColor),
    choose_move((UpdatedBoard, NewColor), NewCounterR, NewCounterB).
  



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









% --------------------- MENU DE DIFICULDADE DA AI ---------------------

% Mostra o menu de dificuldade da AI e obtém a escolha do usuário.
ai_difficulty_menu(Diff) :-
    write('Escolha a dificuldade da AI:'), nl,
    write('1. Fácil'), nl,
    write('2. Difícil'), nl,
    write('Escolha uma opção: '), read(Diff).

% Processa a escolha de dificuldade.
process_difficulty(1, ai_easy) :- !.
process_difficulty(2, ai_hard) :- !.
process_difficulty(_, human) :- % Opção padrão se uma entrada inválida for dada
    write('Opção inválida! Escolhendo modo humano por padrão.'), nl.