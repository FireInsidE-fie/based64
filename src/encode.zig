const std = @import("std");

/// Takes in a string as input, and returns the size in base64 if that string
/// was converted.
fn get_encoded_length(input: []const u8) !usize {
    if (input.len == 0) {
        return (0);
    }
    const encoded_len: usize = try std.math.divCeil(
		usize, input.len, 3
	);
	return (encoded_len * 4);
}

test "get_encoded_length" {
	const len1: usize = try get_encoded_length("wow");
	const len2: usize = try get_encoded_length("");
	const len3: usize = try get_encoded_length("hi");
	const len4: usize = try get_encoded_length("this should work");

	try std.testing.expect(len1 == 4);
	try std.testing.expect(len2 == 0);
	try std.testing.expect(len3 == 4);
	try std.testing.expect(len4 == 24);
}
