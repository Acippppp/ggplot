# 1. Draw tic-tac-toe board.
# 2. Add board and playing loop.
# 3. Add click-to-play.
# 4. Add check for a win.
# 5. Require play on empty square.
# 6. Add computer player.
# 7. Generalize program to play n-by-n, not 3-by-3, tic-tac-toe.

rm(list=ls()) # clear all defined objects

won = function(board, player, debug=FALSE) {
  if (debug) {
    cat(sep="", "player=", player, ", board=", "\n")
    print(board)
  }
  n = dim(board)[1]
  stopifnot(n == dim(board)[2])
  for (i in 1:n) {
    if (all(board[1:n, i] == player) | # won in column i
        all(board[i, 1:n] == player)) { # won in row i
      return(TRUE)
    }
  }
  return(all(diag(board) == player) |   # won in diagonal
           all(diag(board[n:1, ]) == player)) # won in reverse diagonal
}
test.board = matrix(data=c("X","O","", "O","X","O", "X","O","X"), nrow=3, ncol=3)
stopifnot( won(test.board, "X"))
stopifnot(!won(test.board, "O"))
test.board[2, 2] = "O"
stopifnot(!won(test.board, "X"))
stopifnot( won(test.board, "O"))

n = 4
x = rep(x=1:n, each=n)
y = rep(x=1:n, times=n)

plot(x, y, type="n", xlim=c(0, n+1), ylim=c(n+1, 0))
#segments(x0=c(0.5, 0.5, 1.5, 2.5), y0=c(1.5, 2.5, 0.5, 0.5),
#         x1=c(3.5, 3.5, 1.5, 2.5), y1=c(1.5, 2.5, 3.5, 3.5))

segments(x0=c(rep(0.5, n-1), seq(1.5, n-0.5, 1)),
         y0=c(seq(1.5, n-0.5, 1), rep(0.5, n-1)),
         x1=c(rep(n+0.5, n-1), seq(1.5, n-0.5, 1)),
         y1=c(seq(1.5, n-0.5, 1), rep(n+0.5, n-1)))

board = matrix(data=rep("", times=n^2), nrow=n, ncol=n)
player = "X"
for (i in 1:(n^2)) {
  if (player == "X") { # human player
    repeat {
      index = identify(x, y, n=1, plot=FALSE)
      col = x[index]
      row = y[index]
      if (board[row, col] == "") {
        break
      } else {
        text(x=2, y=n+0.7, labels="Please click on empty square.")
      }
    }
  } else { # computer player
    # index = sample(x=which(c(board) == ""), size=1) # BUG!
    # When x is an integer and length(x) is 1, sample(x) samples from 1:x.
    # See ?sample and its example "surprise" and "safer version".
    indices.of.open.squares = which(c(board) == "")
    n.open = length(indices.of.open.squares)
    index = indices.of.open.squares[sample.int(n=n.open, size=1)]
    col = x[index]
    row = y[index]
  }
  board[row, col] = player
  text(x=col, y=row, labels=player)
  cat(sep="", "i=", i, ", player=", player, ", index=", index,
      ", row=", row, ", col=", col, ", board:", "\n")
  print(board)
  if (won(board, player, debug=TRUE)) {
    text(x=2, y=1/3, labels=paste(player, " won!"), col="red")
    break
  }
  player = ifelse(test=(player == "X"), yes="O", no="X")
}