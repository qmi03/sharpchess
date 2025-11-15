const view = @import("view.zig");
const std = @import("std");
test "ansi bg" {
    const pal: view.Color.Palette = .{};
    const bg = view.Color.hexToAnsiBg(pal.black_piece);
    std.debug.print("{s} a {s}\n", .{ bg, view.Color.ansiReset });
}
test "ansi fg" {
    const pal: view.Color.Palette = .{};
    const fg = view.Color.hexToAnsiFg(pal.black_piece);
    std.debug.print("{s} a {s}\n", .{ fg, view.Color.ansiReset });
}
