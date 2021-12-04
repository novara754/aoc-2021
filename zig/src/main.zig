const std = @import("std");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");

const SolutionFn = fn ([]const u8) i32;
const Solution = struct { part1: SolutionFn, part2: SolutionFn };

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});

    const solutions = [_]Solution{ .{ .part1 = day1.part1, .part2 = day1.part2 }, .{ .part1 = day2.part1, .part2 = day2.part2 } };

    for (solutions) |solution, i| {
        const day = i + 1;

        const path = try std.fmt.allocPrint(std.heap.page_allocator, "./data/day{}.txt", .{day});
        defer std.heap.page_allocator.free(path);

        const input = try std.fs.cwd().readFileAlloc(std.heap.page_allocator, path, 1_000_000);
        defer std.heap.page_allocator.free(input);

        std.log.info("Day {}", .{day});
        std.log.info("  Part 1: {}", .{solution.part1(input)});
        std.log.info("  Part 2: {}", .{solution.part2(input)});
    }
}

test "" {
    _ = day1;
    _ = day2;
}
