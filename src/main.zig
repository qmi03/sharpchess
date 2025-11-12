const std = @import("std");
const sharpchess = @import("sharpchess/chess.zig");

pub fn main() !void {
    const board = sharpchess.Chessboard.init();
    sharpchess.printBoard(board);
}
