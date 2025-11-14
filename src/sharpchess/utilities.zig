const chess = @import("chess.zig");
const std = @import("std");
const board = @import("board.zig");
pub const AnsiColorDef = struct {
    light_square: []const u8 = "\x1b[48;5;180m",
    dark_square: []const u8 = "\x1b[48;5;94m",
    white_piece: []const u8 = "\x1b[97m",
    black_piece: []const u8 = "\x1b[30m",
    reset: []const u8 = "\x1b[0m",
};
pub const SquareColor = enum(u1) { dark, light };
pub fn getSquareColorFromCoordinates(r: board.Rank, f: board.File) SquareColor {
    return @enumFromInt(@intFromEnum(r) ^ @intFromEnum(f) & 1);
}
pub fn getSquareColor(sq: board.Square) SquareColor {
    const i = @intFromEnum(sq);
    return @enumFromInt((i ^ (i >> 3)) & 1);
}
pub const PrintBoardRepresentation = struct {
    piece_type: [64]?chess.PieceType,
    piece_color: [64]?chess.PieceColor,
    square_color: [64]SquareColor,
    pub fn init(cb: chess.Chessboard) PrintBoardRepresentation {
        var self: PrintBoardRepresentation = undefined;
        for (0..64) |i| {
            const square_mask: u64 = board.SQUARE_BB[i];
            const piece_index: u4 = block: {
                for (2..14) |p| {
                    if (cb.pieces_bb[p] & square_mask != 0) {
                        break :block @intCast(p);
                    }
                }
                break :block 0;
            };
            if (piece_index == 0) {
                self.piece_color[i] = null;
                self.piece_type[i] = null;
            } else {
                self.piece_color[i] = @enumFromInt(piece_index % 2);
                self.piece_type[i] = @enumFromInt(piece_index / 2 - 1);
            }
            self.square_color[i] = getSquareColor(@enumFromInt(i));
        }
        return self;
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
pub const SquareAnsiRep = struct {
    square_color: []const u8,
    piece_color: []const u8,
    piece: u21,
};

pub fn printBoard(chessboard: chess.Chessboard) !void {
    std.debug.print("\n", .{});
    const color_def: AnsiColorDef = .{};
    const colored_board: PrintBoardRepresentation = .init(chessboard);

    for (0..8) |ri| {
        const r = 7 - ri;
        std.debug.print(" {d} | ", .{r + 1});
        for (0..8) |f| {
            const sq = r * 8 + f;
            const ch: u21 = if (colored_board.piece_type[sq]) |pt| Unicode[@intFromEnum(pt)] else ' ';
            const bg: []const u8 = switch (colored_board.square_color[sq]) {
                .dark => color_def.dark_square,
                .light => color_def.light_square,
            };
            const fg: []const u8 = if (colored_board.piece_color[sq]) |pc| switch (pc) {
                .black => color_def.black_piece,
                .white => color_def.white_piece,
            } else bg;

            std.debug.print("{s}{s}{u} {s}", .{ fg, bg, ch, color_def.reset });
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("    -----------------\n", .{});
    std.debug.print("     a b c d e f g h\n", .{});
}
