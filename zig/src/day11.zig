const std = @import("std");
const util = @import("util.zig");

const Grid = struct {
    energy_levels: [10][10]u8,
    flashed: [10][10]u1,
    total_flashes: u64,

    const Self = @This();

    fn init() Self {
        return .{
            .energy_levels = std.mem.zeroes([10][10]u8),
            .flashed = std.mem.zeroes([10][10]u1),
            .total_flashes = 0,
        };
    }

    fn step(self: *Self) void {
        self.flashed = std.mem.zeroes([10][10]u1);

        for (self.energy_levels) |*row| {
            for (row) |*energy_level| {
                energy_level.* += 1;
            }
        }

        for (self.energy_levels) |*row, y| {
            for (row) |*energy_level, x| {
                if (energy_level.* > 9 and self.flashed[y][x] == 0) {
                    self.flash(y, x);
                }
            }
        }

        for (self.energy_levels) |*row, y| {
            for (row) |*energy_level, x| {
                if (self.flashed[y][x] == 1) {
                    energy_level.* = 0;
                }
            }
        }
    }

    fn flash(self: *Self, y: usize, x: usize) void {
        self.flashed[y][x] = 1;
        self.total_flashes += 1;

        const row = &self.energy_levels[y];

        const min_x = if (x == 0) 0 else x - 1;
        const max_x = if (x == row.len - 1) row.len - 1 else x + 1;
        const min_y = if (y == 0) 0 else y - 1;
        const max_y = if (y == self.energy_levels.len - 1) self.energy_levels.len - 1 else y + 1;

        var i = min_y;
        while (i <= max_y) : (i += 1) {
            var j = min_x;
            while (j <= max_x) : (j += 1) {
                self.energy_levels[i][j] += 1;
                if (self.energy_levels[i][j] > 9 and self.flashed[i][j] == 0) {
                    self.flash(i, j);
                }
            }
        }
    }

    fn allFlashed(self: *const Self) bool {
        for (self.flashed) |row| {
            for (row) |cell| {
                if (cell == 0) {
                    return false;
                }
            }
        }
        return true;
    }

    fn print(self: *const Self, header: []const u8) void {
        std.debug.print("{s}:\n", .{header});
        for (self.energy_levels) |*row| {
            std.debug.print("  ", .{});
            for (row) |energy_level| {
                if (energy_level > 9) {
                    std.debug.print("\x1b[38;5;1mX\x1b[0m", .{});
                } else {
                    std.debug.print("{c}", .{energy_level + '0'});
                }
            }
            std.debug.print("\n", .{});
        }
    }
};

fn parse_input(input: []const u8) Grid {
    var grid = Grid.init();

    var lines = std.mem.tokenize(u8, input, "\n");
    var y: usize = 0;
    while (lines.next()) |line| {
        for (line) |raw_energy_level, x| {
            grid.energy_levels[y][x] = raw_energy_level - '0';
        }
        y += 1;
    }
    return grid;
}

pub fn part1(input: []const u8) !u64 {
    var grid = parse_input(input);
    var i: usize = 0;
    while (i < 100) : (i += 1) {
        grid.step();
    }

    return grid.total_flashes;
}

pub fn part2(input: []const u8) !u64 {
    var grid = parse_input(input);
    var i: usize = 0;
    while (true) : (i += 1) {
        grid.step();
        if (grid.allFlashed()) {
            break;
        }
    }
    return i + 1;
}

test "day 11 part 1" {
    const test_input =
        \\5483143223
        \\2745854711
        \\5264556173
        \\6141336146
        \\6357385478
        \\4167524645
        \\2176841721
        \\6882881134
        \\4846848554
        \\5283751526
    ;
    try std.testing.expectEqual(part1(test_input), 1656);
}

test "day 11 part 2" {
    const test_input =
        \\5483143223
        \\2745854711
        \\5264556173
        \\6141336146
        \\6357385478
        \\4167524645
        \\2176841721
        \\6882881134
        \\4846848554
        \\5283751526
    ;
    try std.testing.expectEqual(part2(test_input), 195);
}
