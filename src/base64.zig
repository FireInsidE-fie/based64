const std = @import("std");

/// Struct containing all characters of base 64 and a helper method returning
/// the index of a given character in base 64.
const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";
        return Base64 {
            ._table = upper ++ lower ++ numbers_symb,
        };
    }

    pub fn _char_at(self: Base64, index: usize) ?u8 {
        if (index > 63 or index < 0)
            return null;
        return self._table[index];
    }

    pub fn encode(self: Base64, a: std.mem.Allocator, input: []const u8) ![]const u8 {
        return null;
    }

    pub fn decode(self: Base64, a: std.mem.Allocator, input: []const u8) ![]const u8 {
        return null;
    }
};

test "Base64._char_at()" {
    const base64 = Base64.init();
    const char1 = base64._char_at(6);
    const char2 = base64._char_at(63);
    const char3 = base64._char_at(32);
    const char4 = base64._char_at(65); // Out of bounds

    std.debug.print("{?} - {?} - {?} - {?}\n", .{char1, char2, char3, char4});
    try std.testing.expect(char1.? == 'G');
    try std.testing.expect(char2.? == '/');
    try std.testing.expect(char3.? == 'g');
    try std.testing.expect(char4 == null);
}