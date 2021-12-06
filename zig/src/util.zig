const std = @import("std");

pub fn parseInt(comptime T: type, str: []const u8) T {
    return std.fmt.parseInt(T, str, 10) catch unreachable;
}

pub fn EnumerateIterator(comptime I: type, comptime T: type) type {
    return struct {
        inner: I,
        index: usize,

        const Self = @This();
        const Item = struct { index: usize, value: T };

        pub fn next(self: *Self) ?Item {
            while (self.inner.next()) |val| {
                self.index += 1;
                return Item{ .index = self.index - 1, .value = val };
            }
            return null;
        }
    };
}

pub fn enumerate(comptime T: type, iterator: anytype) EnumerateIterator(@TypeOf(iterator), T) {
    return .{
        .inner = iterator,
        .index = 0,
    };
}
