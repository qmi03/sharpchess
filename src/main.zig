const chess = @import("engine").chess;
const gui = @import("ui").gui;
const cli = @import("ui").cli;

pub fn main() !void {
    const chessboard = chess.Chessboard.init();
    try cli.printBoard(chessboard);
    try gui.startGame();
}
