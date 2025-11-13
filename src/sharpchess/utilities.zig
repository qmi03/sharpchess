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

const PieceChar: [6]u21 = .{
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

pub const SquareColor = enum(u1) { dark, light };
pub fn getSquareColorFromCoordinates(r: board.Rank, f: board.File) SquareColor {
    return @enumFromInt(@intFromEnum(r) ^ @intFromEnum(f) & 1);
}
pub fn getSquareColor(sq: board.Square) SquareColor {
    const i = @intFromEnum(sq);
    return @enumFromInt((i ^ (i >> 3)) & 1);
}
pub fn getSquareStringRep(chessboard: chess.Chessboard, sq: board.Square, acd: AnsiColorDef) SquareAnsiRep {
    const square_mask = board.SQUARE_BB[@intFromEnum(sq)];
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

pub fn printBoard(chessboard: chess.Chessboard) !void {
    std.debug.print("\n", .{});
    const color_def: AnsiColorDef = .{};
    var rank: u3 = 7;
    while (true) : (rank -%= 1) {
        std.debug.print(" {d}| ", .{@as(u4, rank) + 1});
        var file: u3 = 0;
        while (true) : (file += 1) {
            const square_ansi_rep = getSquareStringRep(chessboard, board.getSquare(@enumFromInt(rank), @enumFromInt(file)), color_def);
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
