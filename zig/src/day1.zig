const std = @import("std");
const util = @import("util.zig");

pub fn part1(input: []const u8) u64 {
    var count: u64 = 0;

    var last_value: i32 = -1;
    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const value = util.parseInt(i32, line);
        if (last_value != -1 and value > last_value) {
            count += 1;
        }
        last_value = value;
    }

    return count;
}

pub fn part2(input: []const u8) u64 {
    var count: u64 = 0;

    var last_values = [3]i32{ undefined, undefined, undefined };
    var lines = std.mem.split(u8, input, "\n");
    var enumerate = util.enumerate([]const u8, lines);
    while (enumerate.next()) |item| {
        const idx = item.index;
        const line = item.value;

        if (line.len == 0) continue;

        const value = util.parseInt(i32, line);

        if (idx > 2 and value > last_values[0]) {
            count += 1;
        }

        var i: usize = 0;
        while (i < 2) : (i += 1) {
            last_values[i] = last_values[i + 1];
        }
        last_values[2] = value;
    }

    return count;
}

test "day 1 part 1" {
    const test_input =
        \\199
        \\200
        \\208
        \\210
        \\200
        \\207
        \\240
        \\269
        \\260
        \\263
    ;

    try std.testing.expectEqual(part1(test_input), 7);
}

test "day 1 part 2" {
    const test_input =
        \\199
        \\200
        \\208
        \\210
        \\200
        \\207
        \\240
        \\269
        \\260
        \\263
    ;

    try std.testing.expectEqual(part2(test_input), 5);
}
