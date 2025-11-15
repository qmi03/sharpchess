const chess = @import("engine").chess;
const ui = @import("ui");

pub fn main() !void {
    const chessboard = chess.Chessboard.init();
    try ui.cli.printBoard(chessboard);
    // try ui.gui.startGame(chessboard);
}
