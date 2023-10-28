:- consult(utils).


initial_board:-
  Board(5,[

        [empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty],
        [empty,empty,empty,empty,empty]

]).





display_header(0):- nl.
display_header(Size):-
    Size > 0,
    write('------'),
    Counter is Size-1,
    display_header(Counter).

display_walls(0).
display_walls(Size):-
  Size > 0,
  write('|     |     |     |     |      | '),nl,
  write('|-----|-----|-----|-----|------| '),
  nl,
  Size1 is Size - 1,
  display_walls(Size1).



display_board(Size):-
    display_header(Size),
    display_walls(Size).