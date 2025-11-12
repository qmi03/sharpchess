const std = @import("std");

pub const empty_set: u64 = 0;
pub const universal_set: u64 = 0xffffffffffffffff;

const RANK_1 = 0;
const RANK_2 = 1;
const RANK_3 = 2;
const RANK_4 = 3;
const RANK_5 = 4;
const RANK_6 = 5;
const RANK_7 = 6;
const RANK_8 = 7;

pub const Color = enum { black, white };
pub const PieceType = enum {
    black_all,
    white_all,
    black_pawn,
    white_pawn,
    black_knight,
    white_knight,
    black_bishop,
    white_bishop,
    black_rook,
    white_rook,
    black_queen,
    white_queen,
    black_king,
    white_king,
};

pub const Chessboard = struct {
    // 0:  black all     1:  white all
    // 2:  black pawn    3:  white pawn
    // 4:  black knight  5:  white knight
    // 6:  black bishop  7:  white bishop
    // 8:  black rook    9:  white rook
    // 10: black queen   11: white queen
    // 12: black king    13: white king
    pieces_bb: [14]u64,
    empty_bb: u64,
    occupied_bb: u64,
    pub fn init() Chessboard {
        const black_pawn: u64 = 0xff << (RANK_7 * 8);
        const white_pawn: u64 = 0xff << (RANK_2 * 8);
        const black_knight: u64 = 0b010_00_010 << (RANK_8 * 8);
        const white_knight: u64 = 0b010_00_010 << (RANK_1 * 8);
        const black_bishop: u64 = 0b001_00_100 << (RANK_8 * 8);
        const white_bishop: u64 = 0b001_00_100 << (RANK_1 * 8);
        const black_rook: u64 = 0b100_00_001 << (RANK_8 * 8);
        const white_rook: u64 = 0b100_00_001 << (RANK_1 * 8);
        const black_queen: u64 = 0b000_10_000 << (RANK_8 * 8);
        const white_queen: u64 = 0b000_10_000 << (RANK_1 * 8);
        const black_king: u64 = 0b000_01_000 << (RANK_8 * 8);
        const white_king: u64 = 0b000_01_000 << (RANK_1 * 8);
        const black_all = black_pawn | black_knight | black_bishop | black_rook | black_queen | black_king;
        const white_all = white_pawn | white_knight | white_bishop | white_rook | white_queen | white_king;
        const occupied_bb = black_all | white_all;
        const empty_bb = ~occupied_bb;
        const all_pieces: [14]u64 = .{
            black_all,
            white_all,
            black_pawn,
            white_pawn,
            black_knight,
            white_knight,
            black_bishop,
            white_bishop,
            black_rook,
            white_rook,
            black_queen,
            white_queen,
            black_king,
            white_king,
        };
        return .{
            .pieces_bb = all_pieces,
            .empty_bb = empty_bb,
            .occupied_bb = occupied_bb,
        };
    }
    pub fn getPieceBitBoard(chessboard: Chessboard, pt: PieceType) u64 {
        return chessboard.pieces_bb[@intFromEnum(pt)];
    }
    pub fn getBlackAll(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_all)];
    }
    pub fn getWhiteAll(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_all)];
    }
    pub fn getBlackPawns(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_pawn)];
    }
    pub fn getWhitePawns(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_pawn)];
    }
    pub fn getBlackKnights(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_knight)];
    }
    pub fn getWhiteKnights(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_knight)];
    }
    pub fn getBlackBishops(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_bishop)];
    }
    pub fn getWhiteBishops(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_bishop)];
    }
    pub fn getBlackRooks(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_rook)];
    }
    pub fn getWhiteRooks(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_rook)];
    }
    pub fn getBlackQueens(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_queen)];
    }
    pub fn getWhiteQueens(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_queen)];
    }
    pub fn getBlackKing(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_king)];
    }
    pub fn getWhiteKing(chessboard: Chessboard) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.white_king)];
    }
    pub fn getPawns(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_pawn) + @intFromEnum(ColorType)];
    }
    pub fn getKnights(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_knight) + @intFromEnum(ColorType)];
    }
    pub fn getBishops(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_bishop) + @intFromEnum(ColorType)];
    }
    pub fn getRooks(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_rook) + @intFromEnum(ColorType)];
    }
    pub fn getQueens(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_queen) + @intFromEnum(ColorType)];
    }
    pub fn getKing(chessboard: Chessboard, ColorType: Color) u64 {
        return chessboard.pieces_bb[@intFromEnum(PieceType.black_king) + @intFromEnum(ColorType)];
    }
};

pub fn printBoard(chessboard: Chessboard) void {
    std.debug.print("Board state:\n", .{});
    std.debug.print("Black pieces: 0x{x}\n", .{chessboard.getBlackAll()});
    std.debug.print("White pieces: 0x{x}\n", .{chessboard.getWhiteAll()});
}

test "init occupied bitboard" {
    const chessboard: Chessboard = .init();
    try std.testing.expectEqual(
        chessboard.occupied_bb,
        chessboard.getBlackPawns() | chessboard.getWhitePawns() |
            chessboard.getBlackKnights() | chessboard.getWhiteKnights() |
            chessboard.getBlackBishops() | chessboard.getWhiteBishops() |
            chessboard.getBlackRooks() | chessboard.getWhiteRooks() |
            chessboard.getBlackQueens() | chessboard.getWhiteQueens() |
            chessboard.getBlackKing() | chessboard.getWhiteKing(),
    );
}
test "init black" {
    const chessboard: Chessboard = .init();
    try std.testing.expectEqual(
        chessboard.getBlackAll(),
        chessboard.getBlackPawns() | chessboard.getBlackKnights() |
            chessboard.getBlackBishops() | chessboard.getBlackRooks() |
            chessboard.getBlackQueens() | chessboard.getBlackKing(),
    );
    try std.testing.expectEqual(0xffff << (RANK_7 * 8), chessboard.getBlackAll());
}
test "init white" {
    const chessboard: Chessboard = .init();
    try std.testing.expectEqual(
        chessboard.getWhiteAll(),
        chessboard.getWhitePawns() | chessboard.getWhiteKnights() |
            chessboard.getWhiteBishops() | chessboard.getWhiteRooks() |
            chessboard.getWhiteQueens() | chessboard.getWhiteKing(),
    );
    try std.testing.expectEqual(0xffff << (RANK_1 * 8), chessboard.getWhiteAll());
}
test "init universal set" {
    const chessboard: Chessboard = .init();
    try std.testing.expectEqual(@as(u64, @as(u64, 0) -% 1), chessboard.empty_bb + chessboard.occupied_bb);
}

test "get methods" {
    const chessboard: Chessboard = .init();
    try std.testing.expectEqual(chessboard.getPawns(.black), chessboard.getBlackPawns());
    try std.testing.expectEqual(chessboard.getKnights(.black), chessboard.getBlackKnights());
    try std.testing.expectEqual(chessboard.getBishops(.black), chessboard.getBlackBishops());
    try std.testing.expectEqual(chessboard.getRooks(.black), chessboard.getBlackRooks());
    try std.testing.expectEqual(chessboard.getQueens(.black), chessboard.getBlackQueens());
    try std.testing.expectEqual(chessboard.getKing(.black), chessboard.getBlackKing());
    try std.testing.expectEqual(chessboard.getPawns(.white), chessboard.getWhitePawns());
    try std.testing.expectEqual(chessboard.getKnights(.white), chessboard.getWhiteKnights());
    try std.testing.expectEqual(chessboard.getBishops(.white), chessboard.getWhiteBishops());
    try std.testing.expectEqual(chessboard.getRooks(.white), chessboard.getWhiteRooks());
    try std.testing.expectEqual(chessboard.getQueens(.white), chessboard.getWhiteQueens());
    try std.testing.expectEqual(chessboard.getKing(.white), chessboard.getWhiteKing());
}
test "no overlapping pieces" {
    const chessboard: Chessboard = Chessboard.init();
    // Verify no pieces overlap by checking that OR equals addition
    const all_pieces_or = chessboard.getBlackPawns() | chessboard.getWhitePawns() |
        chessboard.getBlackKnights() | chessboard.getWhiteKnights() |
        chessboard.getBlackBishops() | chessboard.getWhiteBishops() |
        chessboard.getBlackRooks() | chessboard.getWhiteRooks() |
        chessboard.getBlackQueens() | chessboard.getWhiteQueens() |
        chessboard.getBlackKing() | chessboard.getWhiteKing();
    const all_pieces_add = chessboard.getBlackPawns() + chessboard.getWhitePawns() +
        chessboard.getBlackKnights() + chessboard.getWhiteKnights() +
        chessboard.getBlackBishops() + chessboard.getWhiteBishops() +
        chessboard.getBlackRooks() + chessboard.getWhiteRooks() +
        chessboard.getBlackQueens() + chessboard.getWhiteQueens() +
        chessboard.getBlackKing() + chessboard.getWhiteKing();
    try std.testing.expectEqual(all_pieces_or, all_pieces_add);
}
