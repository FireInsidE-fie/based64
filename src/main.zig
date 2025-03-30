const std = @import("std");

pub fn main() !void {
    const input = "Hi";
    std.debug.print("{d}\n", .{input[0]});
    std.debug.print("{d}\n", .{input[0] >> 2});
}