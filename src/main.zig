const std = @import("std");
const sharpchess = @import("sharpchess/chess.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Hello from main\n", .{});
    try sharpchess.hello_from_chess();
}
