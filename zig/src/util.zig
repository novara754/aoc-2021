const std = @import("std");

pub fn parseInt(str: []const u8) i32 {
    return std.fmt.parseInt(i32, str, 10) catch unreachable;
}
