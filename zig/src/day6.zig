const std = @import("std");
const util = @import("util.zig");

const Key = struct { clock: i32, days_left: usize };

fn simulate_single(clock: i32, days: usize, known: *std.AutoHashMap(Key, u64)) anyerror!u64 {
    var curr_clock = clock;
    if (known.get(.{ .clock = clock, .days_left = days })) |value| {
        return value;
    } else {
        var total: u64 = 1;
        var d: usize = 0;
        while (d < days) : (d += 1) {
            curr_clock -= 1;
            if (curr_clock == -1) {
                curr_clock = 6;
                total += try simulate_single(8, days - d - 1, known);
            }
        }
        try known.put(.{ .clock = clock, .days_left = days }, total);
        return total;
    }
}

fn simulate(input: []const u8, days: usize) !u64 {
    var known = std.AutoHashMap(Key, u64).init(std.heap.page_allocator);
    defer known.deinit();

    var total: u64 = 0;
    var fish = std.mem.tokenize(u8, std.mem.trimRight(u8, input, "\n"), ",");
    while (fish.next()) |f| {
        const clock = util.parseInt(i32, f);

        if (known.get(.{ .clock = clock, .days_left = days })) |value| {
            total += value;
        } else {
            const count = try simulate_single(clock, days, &known);
            try known.put(.{ .clock = clock, .days_left = days }, count);
            total += count;
        }
    }
    return total;
}

pub fn part1(input: []const u8) !u64 {
    return simulate(input, 80);
}

pub fn part2(input: []const u8) !u64 {
    return simulate(input, 256);
}

test "day 5 part 1" {
    const test_input =
        \\3,4,3,1,2
    ;
    try std.testing.expectEqual(part1(test_input), 5934);
}

test "day 5 part 2" {
    const test_input =
        \\3,4,3,1,2
    ;
    try std.testing.expectEqual(part2(test_input), 26984457539);
}
