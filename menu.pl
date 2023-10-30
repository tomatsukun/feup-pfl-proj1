% menu.pl
% Este arquivo é responsável por mostrar o menu inicial ao usuário e obter suas escolhas.





% Bibliotecas necessárias
:- use_module(library(lists)).

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
    process_option(Option).



% Processa a escolha do usuário.
process_option(1) :- % Humano vs Humano
    clear,
    choose_move.


choose_move:-
    write('|-----------------------------|'), nl,
    write('|         Choose Move         |'), nl,
    write('|-----------------------------|'), nl,
    write('| 1. Place piece              |'), nl,
    write('| 2. Move Piece               |'), nl,
    write('|-----------------------------|'), nl,
    write('| Escolha uma opcao: '),
    read(Option),
    process_choose_move(Option).


%% Player chose to place a piece
process_choose_move(1):-
      clear,
      place_piece.



%% Player chose to move a already existing piece
process_choose_move(2):-
      clear,
      move_piece.


%% Place piece 
place_piece:-
  write('|-----------------------------|'), nl,
  write('|    Choose Where to place    |'), nl,
  write('|-----------------------------|'), nl,
  write('| X-Y of the piece |'), nl,
  read(X-Y),

  write('New piece cords '),
  write('('),
  write(X), write(','), write(Y),
  write(')').




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