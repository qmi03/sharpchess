const std = @import("std");
const chess = @import("sharpchess/chess.zig");
const board = @import("sharpchess/board.zig");

pub fn main() !void {
    const chessboard = chess.Chessboard.init();
    try board.printBoard(chessboard);
}
