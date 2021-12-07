const std = @import("std");
const util = @import("util.zig");

fn abs(n: i32) i32 {
    if (n < 0) {
        return -n;
    } else {
        return n;
    }
}

pub fn part1(input: []const u8) !u64 {
    var positions = std.ArrayList(i32).init(std.heap.page_allocator);
    defer positions.deinit();

    var numbers = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), ",");
    while (numbers.next()) |n| {
        const position = util.parseInt(i32, n);
        try positions.append(position);
    }

    std.sort.sort(i32, positions.items, {}, comptime std.sort.asc(i32));

    var median: i32 = undefined;
    if (positions.items.len % 2 == 0) {
        const idx = positions.items.len / 2 - 1;
        median = @divFloor(positions.items[idx] + positions.items[idx + 1], 2);
    } else {
        const idx = (positions.items.len + 1) / 2 - 1;
        median = positions.items[idx];
    }

    var optimal_fuel_use: u64 = 0;
    for (positions.items) |pos| {
        optimal_fuel_use += @intCast(u64, abs(pos - median));
    }

    return optimal_fuel_use;
}

pub fn part2(input: []const u8) !u64 {
    var positions = std.ArrayList(i32).init(std.heap.page_allocator);
    defer positions.deinit();

    var numbers = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), ",");
    while (numbers.next()) |n| {
        const position = util.parseInt(i32, n);
        try positions.append(position);
    }

    std.sort.sort(i32, positions.items, {}, comptime std.sort.asc(i32));

    var optimal_fuel_use: u64 = std.math.maxInt(u64);
    const min = positions.items[0];
    const max = positions.items[positions.items.len - 1];
    var target: i32 = min;
    while (target <= max) : (target += 1) {
        var fuel_use: u64 = 0;
        for (positions.items) |pos| {
            const d = abs(pos - target);
            fuel_use += @intCast(u64, @divFloor(d * (d + 1), 2));
        }
        if (fuel_use < optimal_fuel_use) {
            optimal_fuel_use = fuel_use;
        }
    }

    return optimal_fuel_use;
}

test "day 7 part 1" {
    const test_input =
        \\16,1,2,0,4,2,7,1,2,14
    ;
    try std.testing.expectEqual(part1(test_input), 37);
}

test "day 7 part 2" {
    const test_input =
        \\16,1,2,0,4,2,7,1,2,14
    ;
    try std.testing.expectEqual(part2(test_input), 168);
}
