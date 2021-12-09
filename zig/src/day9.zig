const std = @import("std");
const util = @import("util");

const Cell = struct {
    height: u8,
    basin: bool,
};

const Map = struct {
    data: std.ArrayList(std.ArrayList(Cell)),

    const Self = @This();

    fn init(alloc: *std.mem.Allocator) Self {
        return .{
            .data = std.ArrayList(std.ArrayList(Cell)).init(alloc),
        };
    }

    fn addRow(self: *Self) !*std.ArrayList(Cell) {
        return self.data.addOne();
    }

    fn get(self: *const Self, y: isize, x: isize) Cell {
        if (x < 0 or y < 0 or x >= self.data.items[0].items.len or y >= self.data.items.len) {
            return .{ .height = std.math.maxInt(u8), .basin = false };
        } else {
            return self.data.items[@intCast(usize, y)].items[@intCast(usize, x)];
        }
    }

    fn get_basin_size(self: *Self, y: isize, x: isize) u64 {
        var size: u64 = 1;

        const here = self.get(y, x).height;
        self.data.items[@intCast(usize, y)].items[@intCast(usize, x)].basin = true;

        const above = self.get(y - 1, x);
        if (above.height < 9 and above.height > here and !above.basin) {
            size += self.get_basin_size(y - 1, x);
        }

        const below = self.get(y + 1, x);
        if (below.height < 9 and below.height > here and !below.basin) {
            size += self.get_basin_size(y + 1, x);
        }

        const left = self.get(y, x - 1);
        if (left.height < 9 and left.height > here and !left.basin) {
            size += self.get_basin_size(y, x - 1);
        }

        const right = self.get(y, x + 1);
        if (right.height < 9 and right.height > here and !right.basin) {
            size += self.get_basin_size(y, x + 1);
        }

        return size;
    }
};

fn parse_input(input: []const u8, alloc: *std.mem.Allocator) !Map {
    var map = Map.init(alloc);

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var row = try map.addRow();
        row.* = std.ArrayList(Cell).init(alloc);
        for (line) |height| {
            try row.append(.{ .height = height - '0', .basin = false });
        }
    }

    return map;
}

pub fn part1(input: []const u8) !u64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const alloc = &arena.allocator;
    defer arena.deinit();

    var map = try parse_input(input, alloc);

    var total_risk: u64 = 0;

    for (map.data.items) |row, y| {
        for (row.items) |cell, x| {
            const here = cell.height;
            const above = map.get(@intCast(isize, y) - 1, @intCast(isize, x)).height;
            const below = map.get(@intCast(isize, y) + 1, @intCast(isize, x)).height;
            const left = map.get(@intCast(isize, y), @intCast(isize, x) - 1).height;
            const right = map.get(@intCast(isize, y), @intCast(isize, x) + 1).height;

            if (here < above and here < below and here < left and here < right) {
                total_risk += here + 1;
            }
        }
    }

    return total_risk;
}

pub fn part2(input: []const u8) !u64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const alloc = &arena.allocator;
    defer arena.deinit();

    var map = try parse_input(input, alloc);

    var basins = std.ArrayList(u64).init(alloc);

    for (map.data.items) |row, y| {
        for (row.items) |cell, x| {
            const here = cell.height;
            const above = map.get(@intCast(isize, y) - 1, @intCast(isize, x)).height;
            const below = map.get(@intCast(isize, y) + 1, @intCast(isize, x)).height;
            const left = map.get(@intCast(isize, y), @intCast(isize, x) - 1).height;
            const right = map.get(@intCast(isize, y), @intCast(isize, x) + 1).height;

            if (here < above and here < below and here < left and here < right) {
                try basins.append(map.get_basin_size(@intCast(isize, y), @intCast(isize, x)));
            }
        }
    }

    std.sort.sort(u64, basins.items, {}, comptime std.sort.desc(u64));

    return basins.items[0] * basins.items[1] * basins.items[2];
}

test "day 9 part 1" {
    const test_input =
        \\2199943210
        \\3987894921
        \\9856789892
        \\8767896789
        \\9899965678
    ;
    try std.testing.expectEqual(part1(test_input), 15);
}

test "day 9 part 2" {
    const test_input =
        \\2199943210
        \\3987894921
        \\9856789892
        \\8767896789
        \\9899965678
    ;
    try std.testing.expectEqual(part2(test_input), 1134);
}
