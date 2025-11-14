const Chessboard = @import("chess.zig").Chessboard;
const testing = @import("std").testing;
const board = @import("board.zig");
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
    const white_king_square: board.Square = .e1;
    const black_king_square: board.Square = .e8;
    const white_queen_square: board.Square = .d1;
    const black_queen_square: board.Square = .d8;
    const chessboard: Chessboard = .init();
    try testing.expectEqual(board.squareToBitboard(white_king_square), chessboard.getWhiteKing());
    try testing.expectEqual(board.squareToBitboard(black_king_square), chessboard.getBlackKing());
    try testing.expectEqual(board.squareToBitboard(white_queen_square), chessboard.getWhiteQueens());
    try testing.expectEqual(board.squareToBitboard(black_queen_square), chessboard.getBlackQueens());
}
test "init rook knight pawn squares" {
    const chessboard = Chessboard.init();

    // Test rooks on corners
    try testing.expect(chessboard.getWhiteRooks() == (board.squareToBitboard(.a1) | board.squareToBitboard(.h1)));

    // Test knights
    try testing.expect(chessboard.getWhiteKnights() == (board.squareToBitboard(.b1)) | board.squareToBitboard(.g1));

    // Test bishops
    try testing.expect(chessboard.getWhiteBishops() == (board.squareToBitboard(.c1)) | board.squareToBitboard(.f1));

    // Test pawns on correct rank
    try testing.expectEqual(board.getRankMask(._2), chessboard.getWhitePawns());
    try testing.expectEqual(board.getRankMask(._7), chessboard.getBlackPawns());
}
test "getFileMask" {
    // Test each file mask individually
    try testing.expectEqual(board.FILE_A, board.getFileMask(.a));
    try testing.expectEqual(0x0202020202020202, board.getFileMask(.b));
    try testing.expectEqual(0x0404040404040404, board.getFileMask(.c));
    try testing.expectEqual(0x0808080808080808, board.getFileMask(.d));
    try testing.expectEqual(0x1010101010101010, board.getFileMask(.e));
    try testing.expectEqual(0x2020202020202020, board.getFileMask(.f));
    try testing.expectEqual(0x4040404040404040, board.getFileMask(.g));
    try testing.expectEqual(board.FILE_H, board.getFileMask(.h));

    // Test that each file mask has exactly 8 bits set
    try testing.expectEqual(8, board.popCount(board.getFileMask(.a)));
    try testing.expectEqual(8, board.popCount(board.getFileMask(.d)));
    try testing.expectEqual(8, board.popCount(board.getFileMask(.h)));

    // Test that no files overlap
    try testing.expectEqual(@as(u64, 0), board.getFileMask(.a) & board.getFileMask(.b));
    try testing.expectEqual(@as(u64, 0), board.getFileMask(.d) & board.getFileMask(.e));
    try testing.expectEqual(@as(u64, 0), board.getFileMask(.g) & board.getFileMask(.h));

    // Test that all files together cover the entire board
    const all_files = board.getFileMask(.a) | board.getFileMask(.b) | board.getFileMask(.c) |
        board.getFileMask(.d) | board.getFileMask(.e) | board.getFileMask(.f) |
        board.getFileMask(.g) | board.getFileMask(.h);
    try testing.expectEqual(0xffffffffffffffff, all_files);
}

test "getRankMask" {
    // Test each rank mask individually
    try testing.expectEqual(board.RANK_1, board.getRankMask(._1));
    try testing.expectEqual(0x000000000000ff00, board.getRankMask(._2));
    try testing.expectEqual(0x0000000000ff0000, board.getRankMask(._3));
    try testing.expectEqual(0x00000000ff000000, board.getRankMask(._4));
    try testing.expectEqual(0x000000ff00000000, board.getRankMask(._5));
    try testing.expectEqual(0x0000ff0000000000, board.getRankMask(._6));
    try testing.expectEqual(0x00ff000000000000, board.getRankMask(._7));
    try testing.expectEqual(board.RANK_8, board.getRankMask(._8));

    // Test that each rank mask has exactly 8 bits set
    try testing.expectEqual(8, board.popCount(board.getRankMask(._1)));
    try testing.expectEqual(8, board.popCount(board.getRankMask(._4)));
    try testing.expectEqual(8, board.popCount(board.getRankMask(._8)));

    // Test that no ranks overlap
    try testing.expectEqual(@as(u64, 0), board.getRankMask(._1) & board.getRankMask(._2));
    try testing.expectEqual(@as(u64, 0), board.getRankMask(._4) & board.getRankMask(._5));
    try testing.expectEqual(@as(u64, 0), board.getRankMask(._7) & board.getRankMask(._8));

    // Test that all ranks together cover the entire board
    const all_ranks = board.getRankMask(._1) | board.getRankMask(._2) | board.getRankMask(._3) |
        board.getRankMask(._4) | board.getRankMask(._5) | board.getRankMask(._6) |
        board.getRankMask(._7) | board.getRankMask(._8);
    try testing.expectEqual(0xffffffffffffffff, all_ranks);
}

test "file and rank mask interaction" {
    // Test that file and rank intersect at exactly one square
    const e_file = board.getFileMask(.e);
    const rank_4 = board.getRankMask(._4);
    const e4_square = e_file & rank_4;

    try testing.expectEqual(board.squareToBitboard(.e4), e4_square);
    try testing.expectEqual(1, board.popCount(e4_square));

    // Test corner squares
    try testing.expectEqual(board.squareToBitboard(.a1), board.getFileMask(.a) & board.getRankMask(._1));
    try testing.expectEqual(board.squareToBitboard(.h8), board.getFileMask(.h) & board.getRankMask(._8));

    // Test that getFile and getRank work with masks
    const d5 = board.Square.d5;
    const d5_file_mask = board.getFileMask(board.getFile(d5));
    const d5_rank_mask = board.getRankMask(board.getRank(d5));

    // d5 should be on both its file and rank masks
    try testing.expect((d5_file_mask & board.squareToBitboard(d5)) != 0);
    try testing.expect((d5_rank_mask & board.squareToBitboard(d5)) != 0);
}

test "mask edge cases" {
    // Test that masks work for pawns on starting squares
    const white_pawn_rank = board.getRankMask(._2);
    const black_pawn_rank = board.getRankMask(._7);

    // All white pawns should be on rank 2
    try testing.expectEqual(8, board.popCount(white_pawn_rank));
    // All black pawns should be on rank 7
    try testing.expectEqual(8, board.popCount(black_pawn_rank));

    // Test edge files (important for pawn attack wrapping prevention)
    const a_file = board.getFileMask(.a);
    const h_file = board.getFileMask(.h);

    // Verify NOT_A_FILE and NOT_H_FILE would work correctly
    const not_a_file = ~a_file;
    const not_h_file = ~h_file;

    try testing.expectEqual(56, board.popCount(not_a_file));
    try testing.expectEqual(56, board.popCount(not_h_file));
}
