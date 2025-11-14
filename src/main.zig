const std = @import("std");
const chess = @import("engine").chess;
const utilities = @import("engine").utilities;
const rl = @import("raylib");
const game = @import("gui").game;

pub fn main() !void {
    const chessboard = chess.Chessboard.init();
    try utilities.printBoard(chessboard);
    try game.startGame();
}
