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
pub const File = enum { a, b, c, d, e, f, g, h };
pub const Rank = enum { _1, _2, _3, _4, _5, _6, _7, _8 };

// zig fmt: on
pub fn squareToBitboard(sq: Square) u64 {
    return @as(u64, 1) << @intFromEnum(sq);
}

pub fn getSquare(r: Rank, f: File) Square {
    return @enumFromInt(8 * @intFromEnum(r) + @intFromEnum(f));
}

pub fn getFile(sq: Square) File {
    // Extract last 3 bits (0-7) representing file (a-h)
    return @enumFromInt(@intFromEnum(sq) & 7);
}

pub fn getRank(sq: Square) Rank {
    // Shift right 3 bits to get rank (0-7) representing (1-8)
    return @enumFromInt(@intFromEnum(sq) >> 3);
}

pub fn getFileMask(f: File) u64 {
    return FILE_A << @intFromEnum(f);
}

pub fn getRankMask(r: Rank) u64 {
    return RANK_1 << (@as(u6, @intFromEnum(r)) * 8);
}
pub fn popCount(bb: u64) u7 {
    return @popCount(bb);
}
