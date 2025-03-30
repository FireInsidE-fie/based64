const std = @import("std");

/// Takes in a base 64 string as input, and returns the size in standard if that
/// string was decoded. Ignores = characters at the end.
fn get_decoded_length(input: []const u8) !usize {
    if (input.len == 0) {
        return (0);
    } else if (input.len < 4) {
        return (3);
    }
    const encoded_len = try std.math.divFloor(
        usize, input.len, 4
    );
    var equal_count: usize = 0;
    const equal_index = std.mem.indexOf(u8, input, "=");
    if (equal_index) |index| {
        equal_count = input.len - index;
    }
    return (encoded_len * 3 - equal_count);
}

test "get_encoded_length" {
    const len1: usize = try get_decoded_length("d293");
    // std.debug.print("len1 = {}\n", .{len1});
    const len2: usize = try get_decoded_length("");
    // std.debug.print("len2 = {}\n", .{len2});
    const len3: usize = try get_decoded_length("aGk=");
    // std.debug.print("len3 = {}\n", .{len3});
    const len4: usize = try get_decoded_length("dGhpcyBzaG91bGQgd29yaw==");
    // std.debug.print("len4 = {}\n", .{len4});

    try std.testing.expect(len1 == 3);
    try std.testing.expect(len2 == 0);
    try std.testing.expect(len3 == 2);
    try std.testing.expect(len4 == 16);
}
