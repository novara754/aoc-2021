const std = @import("std");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");
const day4 = @import("day4.zig");
const day5 = @import("day5.zig");
const day6 = @import("day6.zig");
const day7 = @import("day7.zig");
const day8 = @import("day8.zig");
const day9 = @import("day9.zig");
const day10 = @import("day10.zig");

const SolutionFn = fn ([]const u8) anyerror!u64;
const Solution = struct { part1: SolutionFn, part2: SolutionFn };

pub fn main() anyerror!void {
    const solutions = [_]Solution{ .{ .part1 = day1.part1, .part2 = day1.part2 }, .{ .part1 = day2.part1, .part2 = day2.part2 }, .{ .part1 = day3.part1, .part2 = day3.part2 }, .{ .part1 = day4.part1, .part2 = day4.part2 }, .{ .part1 = day5.part1, .part2 = day5.part2 }, .{ .part1 = day6.part1, .part2 = day6.part2 }, .{ .part1 = day7.part1, .part2 = day7.part2 }, .{ .part1 = day8.part1, .part2 = day8.part2 }, .{ .part1 = day9.part1, .part2 = day9.part2 }, .{ .part1 = day10.part1, .part2 = day10.part2 } };

    for (solutions) |solution, i| {
        const day = i + 1;

        const path = try std.fmt.allocPrint(std.heap.page_allocator, "./data/day{}.txt", .{day});
        defer std.heap.page_allocator.free(path);

        const input = try std.fs.cwd().readFileAlloc(std.heap.page_allocator, path, 1_000_000);
        defer std.heap.page_allocator.free(input);

        var start: i128 = std.time.nanoTimestamp();
        const part1 = try solution.part1(input);
        const part1_time = std.time.nanoTimestamp() - start;

        start = std.time.nanoTimestamp();
        const part2 = try solution.part2(input);
        const part2_time = std.time.nanoTimestamp() - start;

        std.debug.print("Day {}\n", .{day});
        std.debug.print("  Part 1: {} ({} ns)\n", .{ part1, part1_time });

        std.debug.print("  Part 2: {} ({} ns)\n", .{ part2, part2_time });
    }
}

test "" {
    _ = day1;
    _ = day2;
    _ = day3;
    _ = day4;
    _ = day5;
    _ = day6;
    _ = day7;
    _ = day8;
    _ = day9;
    _ = day10;
}
