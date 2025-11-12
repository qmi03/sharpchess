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
test "init king queen on correct squares" {
    const white_king_square: square.Square = .e1;
    const black_king_square: square.Square = .e8;
    const white_queen_square: square.Square = .d1;
    const black_queen_square: square.Square = .d8;
    const chessboard: Chessboard = .init();
    try testing.expectEqual(square.squareToBitboard(white_king_square), chessboard.getWhiteKing());
    try testing.expectEqual(square.squareToBitboard(black_king_square), chessboard.getBlackKing());
    try testing.expectEqual(square.squareToBitboard(white_queen_square), chessboard.getWhiteQueens());
    try testing.expectEqual(square.squareToBitboard(black_queen_square), chessboard.getBlackQueens());
}
test "init rook knight pawn squares" {
    const board = Chessboard.init();

    // Test rooks on corners
    try testing.expect(board.getWhiteRooks() == (square.squareToBitboard(.a1) | square.squareToBitboard(.h1)));

    // Test knights
    try testing.expect(board.getWhiteKnights() == (square.squareToBitboard(.b1)) | square.squareToBitboard(.g1));

    // Test bishops
    try testing.expect(board.getWhiteBishops() == (square.squareToBitboard(.c1)) | square.squareToBitboard(.f1));

    // Test pawns on correct rank
    try testing.expectEqual(square.getRankMask(._2), board.getWhitePawns());
    try testing.expectEqual(square.getRankMask(._7), board.getBlackPawns());
}
test "getFileMask" {
    // Test each file mask individually
    try testing.expectEqual(square.FILE_A, square.getFileMask(.a));
    try testing.expectEqual(0x0202020202020202, square.getFileMask(.b));
    try testing.expectEqual(0x0404040404040404, square.getFileMask(.c));
    try testing.expectEqual(0x0808080808080808, square.getFileMask(.d));
    try testing.expectEqual(0x1010101010101010, square.getFileMask(.e));
    try testing.expectEqual(0x2020202020202020, square.getFileMask(.f));
    try testing.expectEqual(0x4040404040404040, square.getFileMask(.g));
    try testing.expectEqual(square.FILE_H, square.getFileMask(.h));

    // Test that each file mask has exactly 8 bits set
    try testing.expectEqual(8, square.popCount(square.getFileMask(.a)));
    try testing.expectEqual(8, square.popCount(square.getFileMask(.d)));
    try testing.expectEqual(8, square.popCount(square.getFileMask(.h)));

    // Test that no files overlap
    try testing.expectEqual(@as(u64, 0), square.getFileMask(.a) & square.getFileMask(.b));
    try testing.expectEqual(@as(u64, 0), square.getFileMask(.d) & square.getFileMask(.e));
    try testing.expectEqual(@as(u64, 0), square.getFileMask(.g) & square.getFileMask(.h));

    // Test that all files together cover the entire board
    const all_files = square.getFileMask(.a) | square.getFileMask(.b) | square.getFileMask(.c) |
        square.getFileMask(.d) | square.getFileMask(.e) | square.getFileMask(.f) |
        square.getFileMask(.g) | square.getFileMask(.h);
    try testing.expectEqual(0xffffffffffffffff, all_files);
}

test "getRankMask" {
    // Test each rank mask individually
    try testing.expectEqual(square.RANK_1, square.getRankMask(._1));
    try testing.expectEqual(0x000000000000ff00, square.getRankMask(._2));
    try testing.expectEqual(0x0000000000ff0000, square.getRankMask(._3));
    try testing.expectEqual(0x00000000ff000000, square.getRankMask(._4));
    try testing.expectEqual(0x000000ff00000000, square.getRankMask(._5));
    try testing.expectEqual(0x0000ff0000000000, square.getRankMask(._6));
    try testing.expectEqual(0x00ff000000000000, square.getRankMask(._7));
    try testing.expectEqual(square.RANK_8, square.getRankMask(._8));

    // Test that each rank mask has exactly 8 bits set
    try testing.expectEqual(8, square.popCount(square.getRankMask(._1)));
    try testing.expectEqual(8, square.popCount(square.getRankMask(._4)));
    try testing.expectEqual(8, square.popCount(square.getRankMask(._8)));

    // Test that no ranks overlap
    try testing.expectEqual(@as(u64, 0), square.getRankMask(._1) & square.getRankMask(._2));
    try testing.expectEqual(@as(u64, 0), square.getRankMask(._4) & square.getRankMask(._5));
    try testing.expectEqual(@as(u64, 0), square.getRankMask(._7) & square.getRankMask(._8));

    // Test that all ranks together cover the entire board
    const all_ranks = square.getRankMask(._1) | square.getRankMask(._2) | square.getRankMask(._3) |
        square.getRankMask(._4) | square.getRankMask(._5) | square.getRankMask(._6) |
        square.getRankMask(._7) | square.getRankMask(._8);
    try testing.expectEqual(0xffffffffffffffff, all_ranks);
}

test "file and rank mask interaction" {
    // Test that file and rank intersect at exactly one square
    const e_file = square.getFileMask(.e);
    const rank_4 = square.getRankMask(._4);
    const e4_square = e_file & rank_4;

    try testing.expectEqual(square.squareToBitboard(.e4), e4_square);
    try testing.expectEqual(1, square.popCount(e4_square));

    // Test corner squares
    try testing.expectEqual(square.squareToBitboard(.a1), square.getFileMask(.a) & square.getRankMask(._1));
    try testing.expectEqual(square.squareToBitboard(.h8), square.getFileMask(.h) & square.getRankMask(._8));

    // Test that getFile and getRank work with masks
    const d5 = square.Square.d5;
    const d5_file_mask = square.getFileMask(square.getFile(d5));
    const d5_rank_mask = square.getRankMask(square.getRank(d5));

    // d5 should be on both its file and rank masks
    try testing.expect((d5_file_mask & square.squareToBitboard(d5)) != 0);
    try testing.expect((d5_rank_mask & square.squareToBitboard(d5)) != 0);
}

test "mask edge cases" {
    // Test that masks work for pawns on starting squares
    const white_pawn_rank = square.getRankMask(._2);
    const black_pawn_rank = square.getRankMask(._7);

    // All white pawns should be on rank 2
    try testing.expectEqual(8, square.popCount(white_pawn_rank));
    // All black pawns should be on rank 7
    try testing.expectEqual(8, square.popCount(black_pawn_rank));

    // Test edge files (important for pawn attack wrapping prevention)
    const a_file = square.getFileMask(.a);
    const h_file = square.getFileMask(.h);

    // Verify NOT_A_FILE and NOT_H_FILE would work correctly
    const not_a_file = ~a_file;
    const not_h_file = ~h_file;

    try testing.expectEqual(56, square.popCount(not_a_file));
    try testing.expectEqual(56, square.popCount(not_h_file));
}
