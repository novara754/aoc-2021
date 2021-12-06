const std = @import("std");
const util = @import("util.zig");

pub fn part1(input: []const u8) u64 {
    var pos: u64 = 0;
    var depth: u64 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var parts = std.mem.split(u8, line, " ");
        const command = parts.next().?;
        const distance = util.parseInt(u64, parts.next().?);

        if (std.mem.eql(u8, command, "forward")) {
            pos += distance;
        } else if (std.mem.eql(u8, command, "up")) {
            depth -= distance;
        } else if (std.mem.eql(u8, command, "down")) {
            depth += distance;
        }
    }

    return pos * depth;
}

pub fn part2(input: []const u8) u64 {
    var pos: u64 = 0;
    var depth: u64 = 0;
    var aim: u64 = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var parts = std.mem.split(u8, line, " ");
        const command = parts.next().?;
        const distance = util.parseInt(u64, parts.next().?);

        if (std.mem.eql(u8, command, "forward")) {
            pos += distance;
            depth += aim * distance;
        } else if (std.mem.eql(u8, command, "up")) {
            aim -= distance;
        } else if (std.mem.eql(u8, command, "down")) {
            aim += distance;
        }
    }

    return pos * depth;
}

test "day 2 part 1" {
    const test_input =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;

    try std.testing.expectEqual(part1(test_input), 150);
}

test "day 2 part 2" {
    const test_input =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;

    try std.testing.expectEqual(part2(test_input), 900);
}
