const std = @import("std");
const chess = @import("sharpchess/chess.zig");
const utilities = @import("sharpchess/utilities.zig");

pub fn main() !void {
    const chessboard = chess.Chessboard.init();
    try utilities.printBoard(chessboard);
}
