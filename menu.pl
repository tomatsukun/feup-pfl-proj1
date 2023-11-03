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
    process_option(Option, 8).



% Processa a escolha do usuário.
process_option(1, Counter) :- % Humano vs Humano
    initial_board(Board),
    clear,
    choose_move(Board, Counter).

process_option(2, Counter) :- % Humano vs Computador
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
    process_choose_bot_dif(Option,Board).

process_choose_bot_dif(1,Board):-
    clear,
    %%choose_move(Board), % turno do player
    random(1, 3, RandNumber), % escolhe random se vai mover ou clocar nova peça
    random(0, 6, Rand_X),
    random(0, 6, Rand_Y),
    ( 1 = 1 -> place_piece_bot(Rand_X-Rand_Y,Board) ; write('Bot moves piece') ).
    


place_piece_bot(X-Y, Board):-
    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,

    run(r,X, Y, Board, UpdatedBoard, Counter, NewCounter),
    continues(NewCounter, UpdatedBoard).
  
continues(NewCounter, Board):-
    write('Do you want to place another piece? (yes/no)'), nl,
    read(Answer),
    (Answer = yes -> place_piece(NewCounter, Board); true).




choose_move(Board, Counter):-
    write('|-----------------------------|'), nl,
    write('|         Choose Move         |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Place piece              |'), nl,
    write('| 2. Move Piece               |'), nl,
    write('|-----------------------------|'), nl,
    write('| Choose an option: '), nl,
    read(Option),
    process_choose_move(Option, Board, Counter).


%% Player chose to place a piece
process_choose_move(1, Board, Counter):-
    clear,
    place_piece(Counter, Board).

%% Player chose to move a already existing piece
process_choose_move(2, Board, Counter):-
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
                choose_move(UpdatedBoard, Counter)
            ; 
                process_choose_move(2, Board, Counter)
            )
        ;
            write('Must be an occupied cell. Please, try again.'), nl, nl, 
            process_choose_move(2, Board, Counter)
        );
        write('No piece found at the specified current position.'), nl, nl, 
        process_choose_move(2, Board, Counter)
    ).


%% Place piece 
place_piece(0, Board) :-
    write('|-----------------------------|'), nl,
    write('|       All pieces placed!    |'), nl,
    write('|-----------------------------|'), nl, nl,  
    display_board(Board, 0).
place_piece(Counter, Board):-
    Counter > 0,
    write('|-----------------------------|'), nl,
    write('|    Choose Where to place    |'), nl,
    write('|-----------------------------|'), nl,
    write('| X-Y of the piece |'), nl,
    read(X-Y),

    write('New piece cords '),
    write('('),
    write(X), write(','), write(Y),
    write(')'), nl,

    run(r, X, Y, Board, UpdatedBoard, Counter, NewCounter),
    continuesO(NewCounter, UpdatedBoard).
  
continuesO(NewCounter, Board):-
    write('Do you want to place another piece? (yes/no)'), nl,
    read(Answer),
    (Answer = yes -> 
        clear,
        place_piece(NewCounter, Board)
    ;   (Answer = no ->
            clear,
            choose_move(Board, NewCounter), nl
        )
    ).




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