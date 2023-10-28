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
    write('Teste opcao 1'),nl,
    start_game(human, human).




process_option(2) :- % Humano vs Computador
    ai_difficulty_menu(Diff), % Primeiro escolhe a dificuldade
    process_difficulty(Diff, Player2),
    start_game(human, Player2).
process_option(3) :- % Computador vs Computador
    ai_difficulty_menu(Diff1), % Escolhe dificuldade para o jogador 1
    process_difficulty(Diff1, Player1),
    ai_difficulty_menu(Diff2), % Escolhe dificuldade para o jogador 2
    process_difficulty(Diff2, Player2),
    start_game(Player1, Player2).
process_option(4) :- % Sair
    !, write('Adeus!'), nl.
process_option(_) :-
    write('Opção inválida!'), nl,
    main_menu.

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