const std = @import("std");
const math = std.math;
const util = @import("util.zig");

const Map = struct {
    data: std.AutoHashMap(Point, i32),

    const Self = @This();

    const Point = struct { x: i32, y: i32 };

    fn init() Self {
        return .{
            .data = std.AutoHashMap(Point, i32).init(std.heap.page_allocator),
        };
    }

    fn deinit(self: *Self) void {
        self.data.deinit();
    }

    fn mark(self: *Self, x: i32, y: i32) void {
        const res = self.data.getOrPut(Point{ .x = x, .y = y }) catch unreachable;
        if (res.found_existing) {
            res.value_ptr.* += 1;
        } else {
            res.value_ptr.* = 1;
        }
    }

    fn get(self: *const Self, x: i32, y: i32) ?i32 {
        return self.data.get(Point{ .x = x, .y = y });
    }

    fn count(self: *const Self) u64 {
        var total: u64 = 0;
        var values = self.data.valueIterator();
        while (values.next()) |v| {
            if (v.* >= 2) total += 1;
        }
        return total;
    }
};

pub fn part1(input: []const u8) u64 {
    var map = Map.init();
    defer map.deinit();

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var parts = std.mem.tokenize(u8, line, " -> ");
        var start = std.mem.tokenize(u8, parts.next().?, ",");
        var end = std.mem.tokenize(u8, parts.next().?, ",");

        const x1 = util.parseInt(i32, start.next().?);
        const y1 = util.parseInt(i32, start.next().?);
        const x2 = util.parseInt(i32, end.next().?);
        const y2 = util.parseInt(i32, end.next().?);

        if (x1 == x2) {
            const min = std.math.min(y1, y2);
            const max = std.math.max(y1, y2);

            var y = min;
            while (y <= max) : (y += 1) {
                map.mark(x1, y);
            }
        } else if (y1 == y2) {
            const min = math.min(x1, x2);
            const max = math.max(x1, x2);

            var x = min;
            while (x <= max) : (x += 1) {
                map.mark(x, y1);
            }
        }
    }

    //var y: i32 = 0;
    //while (y < 10) : (y += 1) {
    //    var x: i32 = 0;
    //    while (x < 10) : (x += 1) {
    //        if (map.get(x, y)) |v| {
    //            std.debug.print("{}", .{v});
    //        } else {
    //            std.debug.print(".", .{});
    //        }
    //    }
    //    std.debug.print("\n", .{});
    //}

    return map.count();
}

fn signum(n: i32) i32 {
    if (n < 0) {
        return -1;
    } else if (n == 0) {
        return 0;
    } else {
        return 1;
    }
}

fn abs(n: i32) i32 {
    if (n < 0) {
        return -n;
    } else {
        return n;
    }
}

pub fn part2(input: []const u8) u64 {
    var map = Map.init();
    defer map.deinit();

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var parts = std.mem.tokenize(u8, line, " -> ");
        var start = std.mem.tokenize(u8, parts.next().?, ",");
        var end = std.mem.tokenize(u8, parts.next().?, ",");

        const x1 = util.parseInt(i32, start.next().?);
        const y1 = util.parseInt(i32, start.next().?);
        const x2 = util.parseInt(i32, end.next().?);
        const y2 = util.parseInt(i32, end.next().?);

        const d = math.max(abs(x2 - x1), abs(y2 - y1));
        const mx = signum(x2 - x1);
        const my = signum(y2 - y1);

        var c: i32 = 0;
        while (c <= d) : (c += 1) {
            const cx = x1 + c * mx;
            const cy = y1 + c * my;
            map.mark(cx, cy);
        }
    }

    return map.count();
}

test "day 5 part 1" {
    const test_input =
        \\0,9 -> 5,9
        \\8,0 -> 0,8
        \\9,4 -> 3,4
        \\2,2 -> 2,1
        \\7,0 -> 7,4
        \\6,4 -> 2,0
        \\0,9 -> 2,9
        \\3,4 -> 1,4
        \\0,0 -> 8,8
        \\5,5 -> 8,2
    ;
    try std.testing.expectEqual(part1(test_input), 5);
}

test "day 5 part 2" {
    const test_input =
        \\0,9 -> 5,9
        \\8,0 -> 0,8
        \\9,4 -> 3,4
        \\2,2 -> 2,1
        \\7,0 -> 7,4
        \\6,4 -> 2,0
        \\0,9 -> 2,9
        \\3,4 -> 1,4
        \\0,0 -> 8,8
        \\5,5 -> 8,2
    ;
    try std.testing.expectEqual(part2(test_input), 12);
}
