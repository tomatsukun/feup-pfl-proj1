# Six Making

## Group Identification

Group T10_Six Making_4

Catarina Isabel Moreira Canelas - 202103628

## Installation and Execution

First, to be able to execute this game, it is required to have SICStus Prolog 4.8 installed and the folder with the source code (src).

Next, consult the file main.pl located in the folder src, like this:

?- consult('./menu.pl').

While using Windows, it is also possible to consult this file by selection the option File and next the option Consult..., and then choose the file main.pl.

Lastly, to run the program and enter the main menu of the game, execute the next command (predicate play/0):

?- play.

## Description of the game

This game is played in a board 5x5 with two players. Each player has a color, red (r) or blue (b). To distinguish the two playes, the pieces of player r are shown with the first letter of its name (P, R, L, B, Q, K) and the pieces of player b are shown with the number representing its stack lenght (1, 2, 3, 4, 5, 6).

This game consists in moving pieces to make a stack of 6 pieces and win the game. There are 6 types of stacks, each piece with its own movement, depending on its height. A Pawn has 1 piece, a Rook has 2 pieces stacked, a Knight has 3 pieces stacked, a Bishop has 4 pieces stacked, a Queen has 5 pieces stacked and a King has 6 pieces stacked. The movement rules are similar to Chess rules. The goal is to make a King, with your color on the top.

Movement rules:
- **Pawn** -> can only move 1 space horizontal or vertical
- **Rook** -> can move any number of spaces horizontal or vertical
- **Knight** -> moves in "L" shape: 1 step orthogonal (horizontal or vertical) and then 1 step diagonal
- **Bishop** -> can move any number of spaces diagonally
- **Queen** -> moves any number of spaces in any direction
- **King** -> has no moves. Wins the game.

Some additional rules are:
- A piece may only be inserted on an empty cell;
- A piece may only be stacked on top of another piece;

We used two sites to gather some information about this game:
- [Official Game Website](https://www.boardspace.net/english/about_sixmaking.html)
- [Rule Book](https://boardspace.net/sixmaking/english/Six-MaKING-rules-Eng-Ger-Fra-Ro-Hu.pdf)

## Game Logic
