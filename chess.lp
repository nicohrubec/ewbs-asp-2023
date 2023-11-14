% assign pieces to tiles
{ rook(1..S, 1..S) } = R :- size(S), n_rooks(R).
{ bishop(1..S, 1..S) } = B :- size(S), n_bishops(B).

% eliminate assignments where a rock and bishop are assigned to the same tile
% TODO: covered by rule below?
:- rook(R, C), bishop(R, C).

% ensure that rooks do not attack other pieces
% rook must not be on the same row or column as any other piece
:- rook(R, C1), bishop(R, C2), C1!=C2.
:- rook(R, C1), rook(R, C2), C1!=C2.
:- rook(R1, C), bishop(R2, C), R1!=R2.
:- rook(R1, C), rook(R2, C), R1!=R2.

% ensure that bishops do not attack other pieces
% for a bishop to be able to attack another piece it must be diagonal to it which means the vertical and horizontal
% distance are equal
:- bishop(R1, C1), bishop(R2, C2), R1!=R2, |R1-R2|=|C1-C2|.
:- bishop(R1, C1), rook(R2, C2), R1!=R2, |R1-R2|=|C1-C2|.