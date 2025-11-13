// Chessboard Endianess: Little Endian
// Meaning:
// Rank 1 .. Rank 8 -> 0..7
// A-File .. H-File -> 0..7
//
// Least Significant File/Rank Mapping: LSF
// Meaning:
// LSF squareIndex = 8*rankIndex + fileIndex
//
// All in all: Little-Endian Rank-File Mapping

// convert square index(0-63) to bitboard rep
// Some constant
pub const FILE_A: u64 = 0x0101010101010101;
pub const FILE_H: u64 = 0x8080808080808080;
pub const RANK_1: u64 = 0x00000000000000ff;
pub const RANK_8: u64 = 0xff00000000000000;
pub const A1_H8_DIAGONAL: u64 = 0x8040201008040201;
pub const H1_A8_ANTIDIAGONAL: u64 = 0x0102040810204080;
pub const LIGHT_SQUARES: u64 = 0x55aa55aa55aa55aa;
pub const DARK_SQUARES: u64 = 0xaa55aa55aa55aa55;

// zig fmt: off
pub const Square = enum {
  a1, b1, c1, d1, e1, f1, g1, h1,
  a2, b2, c2, d2, e2, f2, g2, h2,
  a3, b3, c3, d3, e3, f3, g3, h3,
  a4, b4, c4, d4, e4, f4, g4, h4,
  a5, b5, c5, d5, e5, f5, g5, h5,
  a6, b6, c6, d6, e6, f6, g6, h6,
  a7, b7, c7, d7, e7, f7, g7, h7,
  a8, b8, c8, d8, e8, f8, g8, h8
};
pub const Direction = enum(comptime_int) {
    north_west = 7,     north = 8,    north_east = 9,
    west = -1,                        east = 1,
    south_west = -9,    south = -8,   south_east = -7,
};
// zig fmt: on
pub const File = enum(u3) { a, b, c, d, e, f, g, h };
pub const Rank = enum(u3) { _1, _2, _3, _4, _5, _6, _7, _8 };
pub const SquareColor = enum(u1) { dark, light };

// zig fmt: on
pub const SQUARE_BB: [64]u64 = block: {
    var arr: [64]u64 = undefined;
    for (0..arr.len) |i| {
        arr[i] = @as(u64, 1) << i;
    }
    break :block arr;
};
pub fn squareToBitboard(sq: Square) u64 {
    return SQUARE_BB[@intFromEnum(sq)];
}

pub const RANK_MASKS: [8]u64 = block: {
    var arr: [8]u64 = undefined;
    for (0..arr.len) |i| {
        arr[i] = RANK_1 << (i * 8);
    }
    break :block arr;
};

pub const FILE_MASKS: [8]u64 = block: {
    var arr: [8]u64 = undefined;
    for (0..arr.len) |i| {
        arr[i] = FILE_A << i;
    }
    break :block arr;
};

pub fn getFileMask(f: File) u64 {
    return FILE_MASKS[@intFromEnum(f)];
}

pub fn getRankMask(r: Rank) u64 {
    return RANK_MASKS[@intFromEnum(r)];
}

pub fn getSquare(r: Rank, f: File) Square {
    return @enumFromInt(8 * @as(u64, @intFromEnum(r)) + @intFromEnum(f));
}

pub fn getFile(sq: Square) File {
    // Extract last 3 bits (0-7) representing file (a-h)
    return @enumFromInt(@intFromEnum(sq) & 7);
}

pub fn getRank(sq: Square) Rank {
    // Shift right 3 bits to get rank (0-7) representing (1-8)
    return @enumFromInt(@intFromEnum(sq) >> 3);
}

pub fn popCount(bb: u64) u7 {
    return @popCount(bb);
}
const chess = @import("chess.zig");
pub const SquareAnsiRep = struct {
    square_color: []const u8,
    piece_color: []const u8,
    piece: u21,
};

pub fn getSquareColorFromCoordinates(r: Rank, f: File) SquareColor {
    return @enumFromInt(@intFromEnum(r) ^ @intFromEnum(f) & 1);
}
pub fn getSquareColor(sq: Square) SquareColor {
    const i = @intFromEnum(sq);
    return @enumFromInt((i ^ (i >> 3)) & 1);
}
pub const AnsiColorDef = struct {
    light_square: []const u8 = "\x1b[48;5;180m",
    dark_square: []const u8 = "\x1b[48;5;94m",
    white_piece: []const u8 = "\x1b[97m",
    black_piece: []const u8 = "\x1b[30m",
    reset: []const u8 = "\x1b[0m",
};

const PieceChar: [6]u21 = .{
    '♟',
    '♞',
    '♝',
    '♜',
    '♛',
    '♚',
};
pub fn getSquareStringRep(chessboard: chess.Chessboard, sq: Square, acd: AnsiColorDef) SquareAnsiRep {
    const square_mask = SQUARE_BB[@intFromEnum(sq)];
    const square_color = switch (getSquareColor(sq)) {
        .dark => acd.dark_square,
        .light => acd.light_square,
    };
    var piece: u21 = undefined;
    var piece_color: []const u8 = undefined;
    if ((chessboard.getBlackPawns() & square_mask) != 0) {
        piece = PieceChar[0];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhitePawns() & square_mask) != 0) {
        piece = PieceChar[0];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }

    if ((chessboard.getBlackKnights() & square_mask) != 0) {
        piece = PieceChar[1];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhiteKnights() & square_mask) != 0) {
        piece = PieceChar[1];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getBlackBishops() & square_mask) != 0) {
        piece = PieceChar[2];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhiteBishops() & square_mask) != 0) {
        piece = PieceChar[2];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getBlackRooks() & square_mask) != 0) {
        piece = PieceChar[3];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhiteRooks() & square_mask) != 0) {
        piece = PieceChar[3];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getBlackQueens() & square_mask) != 0) {
        piece = PieceChar[4];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhiteQueens() & square_mask) != 0) {
        piece = PieceChar[4];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getBlackKing() & square_mask) != 0) {
        piece = PieceChar[5];
        piece_color = acd.black_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    if ((chessboard.getWhiteKing() & square_mask) != 0) {
        piece = PieceChar[5];
        piece_color = acd.white_piece;
        return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
    }
    piece = ' ';
    piece_color = square_color;
    return .{ .piece = piece, .piece_color = piece_color, .square_color = square_color };
}

const std = @import("std");
pub fn printBoard(chessboard: chess.Chessboard) !void {
    std.debug.print("\n", .{});
    const color_def: AnsiColorDef = .{};
    var rank: u3 = 7;
    while (true) : (rank -%= 1) {
        std.debug.print(" {d}| ", .{@as(u4, rank) + 1});
        var file: u3 = 0;
        while (true) : (file += 1) {
            const square_ansi_rep = getSquareStringRep(chessboard, getSquare(@enumFromInt(rank), @enumFromInt(file)), color_def);
            std.debug.print("{s}{s}{u} {s}", .{ square_ansi_rep.piece_color, square_ansi_rep.square_color, square_ansi_rep.piece, color_def.reset });
            if (file == 7) break;
        }
        std.debug.print("\n", .{});
        if (rank == 0) {
            std.debug.print("    ----------------\n", .{});
            std.debug.print("    a b c d f e g h\n", .{});
            break;
        }
    }
}
