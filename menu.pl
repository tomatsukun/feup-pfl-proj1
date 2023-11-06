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



% Processa a escolha do usuário.
% opcao humano - humano (player - player)
process_option(1, Counters) :- % Humano vs Humano
    initial_board(Board),
    clear,
    random_select(Color, [r, b], _Rest),
    choose_move(Board, Color, Counters).

process_option(2, Counters) :- % Humano vs Computador
    initial_board(Board),
    clear,
    choose_bot_dif(Board, Counters).

process_option(4, _). % sair
    
    
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

process_choose_bot_dif(1, Board, Counters):-
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
        write('| Choose an option: '),
        read(Option),nl,
        process_choose_move_vsbot(Option, Board, Color, Counters)
    ). % turno do player
    
    
%% Player chose to place a piece
process_choose_move_vsbot(1, Board, Color, Counters):-
    write('     0     1     2     3     4'), nl,
    display_board(Board,0),nl,
    place_piece_pvsbot(Counters, Board, Color).

%% Player chose to move a piece
process_choose_move_vsbot(2, Board, Color, Counters):-
    move_piece_pvsbot(Board, Color, Counters).

place_piece_pvsbot((0, _CounterB), Board, r) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    process_choose_bot_dif(1, (0,_CounterB),Board).


place_piece_pvsbot((_CounterR, 0), Board, b) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
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

    %player coloca a peça
    insert_piece(r, X, Y, Board, UpdatedBoard, Counters, NewCounters, NewColor),

    %% bot escolhe se mete ou move
    random(1, 6, RandNumber), % escolhe random se vai mover ou colocar nova peça sendo a chance de mover supostamente 20%
    ( 2 = 2 -> %% o bot nao vai coiseguir mover só colocar novas peças
        move_piece_bot(NewCounters, UpdatedBoard,  NewColor)
      ; 
        place_piece_bot(NewCounters, UpdatedBoard, NewColor)
        
    ).

move_piece_pvsbot(Board, Color, Counters):-
write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, r, UpdatedBoard), nl,
                switch_color(Color, NewColor),
                place_piece_bot(Counters,UpdatedBoard, NewColor),
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




% process_choose_move_bot(2, Board, Color, CounterR, CounterB):-
move_piece_bot((NewCounterR, NewCounterB), Board, Color):-
  ( NewCounterB = 8 -> %% obriga o bot a por sempre uma peça na primeira jogada
      place_piece_bot((NewCounterR, NewCounterB), Board, Color)
  
  ; 
    (NewCounterB < 3 -> 
      %write('Bot moves piece'),nl, %random_select(Color, [r, b], _Rest),

    write('Chega aqui0!'),
    %random_select((CurrentX,CurrentY),[(0,0),(0,1),(0,2),(0,3),(0,4),(1,0),(1,1),(1,2),(1,3),(1,4),(2,0),(2,1),(2,2),(2,3),(2,4),(3,0),(3,1),(3,2),(3,3),(3,4),(4,0),(4,1),(4,2),(4,3),(4,4)],_Rest),
    random_XY_generator(CurrentX, CurrentY),

     (check_piece(Board, CurrentX, CurrentY) ->
       get_length(Board, CurrentX, CurrentY, Length),
       write('Chega aqui1!'),
       random_select((NewX, NewY), [(0,0),(0,1),(0,2),(0,3),(0,4),(1,0),(1,1),(1,2),(1,3),(1,4),(2,0),(2,1),(2,2),(2,3),(2,4),(3,0),(3,1),(3,2),(3,3),(3,4),(4,0),(4,1),(4,2),(4,3),(4,4)],_Rest),
       write('Chega aqui2!'),
       %%random_XY_generator(NewX, NewY),
        (check_piece(Board, NewX, NewY) -> 
          (validate_move_bot(CurrentX, CurrentY, NewX, NewY, Length) -> 
              move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, b, UpdatedBoard), 
              switch_color(Color, NewColor),
              write('Bot moved the piece at ('),
              write(CurrentX),write('-'),write(CurrentY),
              write(') to '),
              write('('),
              write(NewX),write('-'),write(NewY),
              write(')'),nl,
              write('Chega aqui!'),
              process_choose_bot_dif(1, UpdatedBoard, NewCounters)
          
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
      






place_piece_bot(Counters, Board, Color):-
    hasPiecesLeft(Counters, Color),
    random_XY_generator(Rand_X,Rand_Y),
    run_bot(b, Rand_X, Rand_Y, Board, UpdatedBoard, Counters, NewCounters, NewColor),
    process_choose_bot_dif(1, UpdatedBoard, NewCounters).









%% Bot chose to move a already existing piece
%% primeiro precisa de saber quais peças tem
%% depois pega numa das que tem e move para um sitio
%% 
process_choose_move_bot(2, Board, Color, CounterR, CounterB):-
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
        process_choose_move(2, Board, Color, CounterR, CounterB)
    ).











  
continues(NewCounter, Board):-
    write('Do you want to place another piece? (yes/no)'), nl,
    read(Answer),
    (Answer = yes -> place_piece(NewCounter, Board); true).


% -------------------- PLAYER -------------------------

choose_move(Board, Color, Counters):-
    (check_six_maKING(Board, Winner) ->
        write('The winner is: '),
        write(Winner), nl,
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
    write('Enter the current position (X-Y) of the piece you want to move: '), nl,
    read(CurrentX-CurrentY),
    (check_piece(Board, CurrentX, CurrentY) ->
        get_length(Board, CurrentX, CurrentY, Length), 
        write('Enter the new position (X-Y) for the piece: '), nl, 
        read(NewX-NewY),
        (check_piece(Board, NewX, NewY) ->
            (validate_move(CurrentX, CurrentY, NewX, NewY, Length) ->
                move_piece_logic(Board, CurrentX, CurrentY, NewX, NewY, UpdatedBoard), nl,
                switch_color(Color, NewColor),
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

hasPiecesLeft((CounterR, _CounterB), r):-
    CounterR > 0.

hasPiecesLeft((_CounterR, CounterB), b):-
    CounterB > 0.

%% Place piece 
place_piece((0, CounterB), Board, r) :-
    nl,
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
    choose_move(Board, r, (0, CounterB)).

place_piece((CounterR, 0), Board, b) :-
    nl,
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0),
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