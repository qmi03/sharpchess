const std = @import("std");

pub fn hello_from_chess() !void {
    std.debug.print("Hello {s}\n", .{"chess"});
}
