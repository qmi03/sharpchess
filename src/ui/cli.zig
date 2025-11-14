const chess = @import("engine").chess;
const std = @import("std");
const BoardView = @import("BoardView.zig").BoardView;
const Color = @import("BoardView.zig").Color;

pub fn printBoard(chessboard: chess.Chessboard) !void {
    std.debug.print("\n", .{});
    const view: BoardView = .init(chessboard, .{});

    for (0..8) |ri| {
        const r = 7 - ri;
        std.debug.print(" {d} | ", .{r + 1});
        for (0..8) |f| {
            const sq = r * 8 + f;
            const s = view.squares[sq];

            std.debug.print("{s}{s}{u} {s}", .{ Color.hexToAnsiBg(s.bg), Color.hexToAnsiFg(s.fg), s.codepoint, Color.ansiReset });
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("    -----------------\n", .{});
    std.debug.print("     a b c d e f g h\n", .{});
}
