const Chessboard = @import("chess.zig").Chessboard;
const testing = @import("std").testing;
const square = @import("square.zig");
test "init occupied bitboard" {
    const chessboard: Chessboard = .init();
    try testing.expectEqual(
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
    try testing.expectEqual(
        chessboard.getBlackAll(),
        chessboard.getBlackPawns() | chessboard.getBlackKnights() |
            chessboard.getBlackBishops() | chessboard.getBlackRooks() |
            chessboard.getBlackQueens() | chessboard.getBlackKing(),
    );
    try testing.expectEqual(0xffff << (6 * 8), chessboard.getBlackAll());
}
test "init white" {
    const chessboard: Chessboard = .init();
    try testing.expectEqual(
        chessboard.getWhiteAll(),
        chessboard.getWhitePawns() | chessboard.getWhiteKnights() |
            chessboard.getWhiteBishops() | chessboard.getWhiteRooks() |
            chessboard.getWhiteQueens() | chessboard.getWhiteKing(),
    );
    try testing.expectEqual(0xffff, chessboard.getWhiteAll());
}
test "init universal set" {
    const chessboard: Chessboard = .init();
    try testing.expectEqual(@as(u64, @as(u64, 0) -% 1), chessboard.empty_bb + chessboard.occupied_bb);
}

test "get methods" {
    const chessboard: Chessboard = .init();
    try testing.expectEqual(chessboard.getPawns(.black), chessboard.getBlackPawns());
    try testing.expectEqual(chessboard.getKnights(.black), chessboard.getBlackKnights());
    try testing.expectEqual(chessboard.getBishops(.black), chessboard.getBlackBishops());
    try testing.expectEqual(chessboard.getRooks(.black), chessboard.getBlackRooks());
    try testing.expectEqual(chessboard.getQueens(.black), chessboard.getBlackQueens());
    try testing.expectEqual(chessboard.getKing(.black), chessboard.getBlackKing());
    try testing.expectEqual(chessboard.getPawns(.white), chessboard.getWhitePawns());
    try testing.expectEqual(chessboard.getKnights(.white), chessboard.getWhiteKnights());
    try testing.expectEqual(chessboard.getBishops(.white), chessboard.getWhiteBishops());
    try testing.expectEqual(chessboard.getRooks(.white), chessboard.getWhiteRooks());
    try testing.expectEqual(chessboard.getQueens(.white), chessboard.getWhiteQueens());
    try testing.expectEqual(chessboard.getKing(.white), chessboard.getWhiteKing());
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
    try testing.expectEqual(all_pieces_or, all_pieces_add);
}
