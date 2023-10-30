:- consult(utils).

%peças do jogo

%Pecas = [ [P1, R1, K1, B1, Q1, K1], [P2, R2, K2, B2, Q2, K2]].  %cada jogador tem as suas peças (pawn, rook, knight, bishop, queen and king)

% Definindo as posições x, y, z para cada peça
%posicao(P1, (x1, y1)).
%posicao(R1, (x2, y2)).
%posicao(K1, (x3, y3)).
%posicao(B1, (x4, y4)).
%posicao(Q1, (x5, y5)).
%posicao(K1, (x6, y6)).

%posicao(P2, (x7, y7)).
%posicao(R2, (x8, y8)).
%posicao(K2, (x9, y9)).
%posicao(B2, (x10, y10)).
%posicao(Q2, (x11, y11)).
%posicao(K2, (x12, y12)).

% Obtendo a lista de posições
%lista_de_posicoes(Posicoes) :-
    %pecas(Pecas),
    %maplist(posicao, Pecas, Posicoes).


%celulas do board
cell(empty, ' c ').

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
initial_board:-
    Board = [
        [empty, empty, empty, empty, empty],
        [empty, empty, empty, empty, empty],
        [empty, empty, empty, empty, empty],
        [empty, empty, empty, empty, empty],
        [empty, empty, empty, empty, empty]
    ],
    display_board(Board).
