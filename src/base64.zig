const std = @import("std");
const get_encoded_length = @import("encode.zig").get_encoded_length;
const get_decoded_length = @import("decode.zig").get_decoded_length;

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

    pub fn _char_index(self: Base64, char: u8) u8 {
        if (char == '=')
            return 64;

        var index: u8 = 0;
        for (0..63) |i| {
            if (self._char_at(i) == char) {
                break;
            }
            index += 1;
        }

        return index;
    }

    pub fn encode(self: Base64, a: std.mem.Allocator, input: []const u8) ![]const u8 {
        if (input.len == 0) {
            return "";
        }

        const output_size = try get_encoded_length(input);
        var output = try a.alloc(u8, output_size);
        var buffer = [3]u8{0, 0, 0};
        var count: u8 = 0;
        var iout: u64 = 0;

        for (input, 0..) |_, i| {
            buffer[count] = input[i];
            count += 1;
            if (count == 3) {
                output[iout] = self._char_at(buffer[0] >> 2);
                output[iout + 1] = self._char_at(
                    ((buffer[0] & 0x03) << 2) + (buffer[2] >> 6)
                );
                output[iout + 2] = self._char_at(
                    ((buffer[1] & 0x0f) << 2) + (buffer[2] >> 6)
                );
                output[iout + 3] = self._char_at(buffer[2] & 0x3f);
                iout += 4;
                count = 0;
            }
        }

        if (count == 1) {
            output[iout] = self._char_at(buffer[0] >> 2);
            output[iout + 1] = self._char_at(
                (buffer[0] & 0x03) << 4
            );
            output[iout + 2] = '=';
            output[iout + 3] = '=';
        }
        if (count == 3) {
            output[iout] = self._char_at(buffer[0] >> 2);
            output[iout + 1] = self._char_at(
                ((buffer[0] & 0x03) << 4) + (buffer[1] >> 4)
            );
            output[iout + 2] = self._char_at(
                (buffer[1] & 0x0f) << 2
            );
            output[iout + 3] = '=';
            iout += 4;
        }

        return output;
    }

    pub fn decode(self: Base64, a: std.mem.Allocator, input: []const u8) ![]const u8 {
        if (input.len == 0) {
            return "";
        }
        const output_size = try get_decoded_length(input);
        var output = try a.alloc(u8, output_size);
        var count: u8 = 0;
        var iout: u64 = 0;
        var buffer = [4]u8{0, 0, 0, 0};

        for (0..input.len) |i| {
            buffer[count] = self._char_index(input[i]);
            count += 1;
            if (count == 4) {
                output[iout] = (buffer[0] << 2) + (buffer[1] >> 4);
                if (buffer[2] != 64) {
                    output[iout + 1] = (buffer[1] << 4) + (buffer[2] >> 2);
                }
                if (buffer[3] != 64) {
                    output[iout + 2] = (buffer[2] << 6) + buffer[3];
                }

                iout += 3;
                count = 0;
            }
        }
        
        return output;
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