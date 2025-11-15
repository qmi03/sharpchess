const chess = @import("engine").chess;
const std = @import("std");
const board = @import("engine").board;
const rl = @import("raylib");
pub const BoardView = struct {
    pub fn get(cb: chess.Chessboard) [64]?chess.PieceIndex {
        var view: [64]?chess.PieceIndex = undefined;
        for (0..64) |i| {
            const square_mask = board.SQUARE_BB[i];
            const piece_index: ?u4 = for (2..14) |p| {
                if (cb.pieces_bb[p] & square_mask != 0) break @intCast(p);
            } else null;
            view[i] = if (piece_index) |pi| @enumFromInt(pi) else null;
        }
        return view;
    }
};

const SquareColor = enum(u1) { dark, light };
pub const SQUARE_COLOR: [64]SquareColor = blk: {
    var self: [64]SquareColor = undefined;
    for (0..64) |i| {
        self[i] = @enumFromInt((i ^ (i >> 3)) & 1);
    }
    break :blk self;
};
pub const Color = struct {
    pub const Palette = struct {
        light_square: u32 = 0xFFCCFFCC,
        dark_square: u32 = 0xFF669966,
        white_piece: u32 = 0xFFFFFFFF,
        black_piece: u32 = 0xFF000000,
    };
    pub const ansiReset = "\x1b[0m";
    pub fn hexToAnsiFg(color: u32) [20]u8 {
        const r = (color >> 16) & 0xFF;
        const g = (color >> 8) & 0xFF;
        const b = color & 0xFF;
        var buf = std.mem.zeroes([20]u8);
        _ = std.fmt.bufPrintZ(&buf, "\x1b[38;2;{d};{d};{d}m", .{ r, g, b }) catch unreachable;
        return buf;
    }

    pub fn hexToAnsiBg(color: u32) [20]u8 {
        const r = (color >> 16) & 0xFF;
        const g = (color >> 8) & 0xFF;
        const b = color & 0xFF;
        var buf = std.mem.zeroes([20]u8);
        _ = std.fmt.bufPrintZ(&buf, "\x1b[48;2;{d};{d};{d}m", .{ r, g, b }) catch unreachable;
        return buf;
    }
    fn hexToRaylibColor(hex: u32) rl.Color {
        return .{
            .r = @intCast((hex >> 16) & 0xFF),
            .g = @intCast((hex >> 8) & 0xFF),
            .b = @intCast(hex & 0xFF),
            .a = 255,
        };
    }
};
