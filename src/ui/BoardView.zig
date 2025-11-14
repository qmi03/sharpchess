const chess = @import("engine").chess;
const std = @import("std");
const board = @import("engine").board;
pub const SquareColor = enum(u1) { dark, light };
pub fn getSquareColor(sq_index: usize) SquareColor {
    return @enumFromInt((sq_index ^ (sq_index >> 3)) & 1);
}
pub const Palette = struct {
    light_square: u32 = 0xFFCCFFCC,
    dark_square: u32 = 0xFF669966,
    white_piece: u32 = 0xFFFFFFFF,
    black_piece: u32 = 0xFF000000,
};
pub const Color = struct {
    pub const ansiReset = "\x1b[0m";
    pub fn hexToAnsiFg(color: u32) [20]u8 {
        const r = (color >> 16) & 0xFF;
        const g = (color >> 8) & 0xFF;
        const b = color & 0xFF;
        var buf: [20]u8 = undefined;
        const slice = std.fmt.bufPrint(&buf, "\x1b[38;2;{d};{d};{d}m", .{ r, g, b }) catch unreachable;
        @memset(buf[slice.len..], 0); // Fill bytes from slice.len to end with 0
        return buf;
    }

    pub fn hexToAnsiBg(color: u32) [20]u8 {
        const r = (color >> 16) & 0xFF;
        const g = (color >> 8) & 0xFF;
        const b = color & 0xFF;
        var buf: [20]u8 = undefined;
        const slice = std.fmt.bufPrint(&buf, "\x1b[48;2;{d};{d};{d}m", .{ r, g, b }) catch unreachable;
        @memset(buf[slice.len..], 0); // Fill bytes from slice.len to end with 0
        return buf;
    }
};
pub const BoardView = struct {
    squares: [64]SquareView,
    pub const SquareView = struct {
        codepoint: u21,
        fg: u32,
        bg: u32,
    };
    pub fn init(cb: chess.Chessboard, pal: Palette) BoardView {
        var view: BoardView = undefined;
        for (0..64) |i| {
            const square_mask = board.SQUARE_BB[i];
            const piece_index: ?u4 = for (2..14) |p| {
                if (cb.pieces_bb[p] & square_mask != 0) break @intCast(p);
            } else null;
            const bg: u32 = switch (getSquareColor(i)) {
                .dark => pal.dark_square,
                .light => pal.light_square,
            };

            if (piece_index) |pi| {
                const piece_color: chess.PieceColor = @enumFromInt(pi % 2);
                const piece_type: chess.PieceType = @enumFromInt(pi / 2 - 1);
                view.squares[i] = .{
                    .codepoint = Unicode[@intFromEnum(piece_type)],
                    .fg = switch (piece_color) {
                        .black => pal.black_piece,
                        .white => pal.white_piece,
                    },
                    .bg = bg,
                };
            } else {
                view.squares[i] = .{
                    .codepoint = ' ',
                    .fg = bg, // same as background → invisible piece
                    .bg = bg,
                };
            }
        }
        return view;
    }
};

const Unicode: [6]u21 = .{
    '♟',
    '♞',
    '♝',
    '♜',
    '♛',
    '♚',
};
