const chess = @import("engine").chess;
const std = @import("std");
const view = @import("view.zig");
const Color = @import("view.zig").Color;

pub const PIECE_CODE: [13]u21 = .{ ' ', '♟', '♙', '♞', '♘', '♝', '♗', '♜', '♖', '♛', '♕', '♚', '♔' };
pub fn printBoard(chessboard: chess.Chessboard) !void {
    var buf: [128]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&buf);
    try stdout_writer.interface.print("\n", .{});

    const board_view = view.BoardView.get(chessboard);
    const palete: view.Color.Palette = .{};

    for (0..8) |ri| {
        const r = 7 - ri;
        try stdout_writer.interface.print(" {d} | ", .{r + 1});
        for (0..8) |f| {
            const square_index = r * 8 + f;
            const piece_index = board_view[square_index];
            const codepoint_index = if (piece_index) |pi| @intFromEnum(pi) - 1 else 0;
            const codepoint = PIECE_CODE[codepoint_index];
            const square_color = view.SQUARE_COLOR[square_index];
            const bg: u32 = switch (square_color) {
                .dark => palete.dark_square,
                .light => palete.light_square,
            };
            const fg: u32 = if (codepoint_index % 2 == 0) palete.white_piece else palete.black_piece;

            try stdout_writer.interface.print("{s}{s}{u} {s}", .{ Color.hexToAnsiBg(bg), Color.hexToAnsiFg(fg), codepoint, Color.ansiReset });
        }
        try stdout_writer.interface.print("\n", .{});
    }
    try stdout_writer.interface.print("    -----------------\n", .{});
    try stdout_writer.interface.print("     a b c d e f g h\n", .{});
}
