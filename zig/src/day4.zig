const std = @import("std");
const util = @import("util.zig");

const Board = struct {
    grid: [5][5]i32,
    marked: [5][5]bool,
    done: bool,

    const Self = @This();

    fn init() Self {
        return .{ .grid = undefined, .marked = std.mem.zeroes([5][5]bool), .done = false };
    }

    fn mark(self: *Self, call: i32) ?i32 {
        for (self.grid) |row, y| {
            for (row) |cell, x| {
                if (cell == call) {
                    self.marked[y][x] = true;

                    if (self.row_marked(y) or self.col_marked(x)) {
                        self.done = true;
                        return self.unmarked_sum();
                    }
                }
            }
        }

        return null;
    }

    fn row_marked(self: *const Self, row: usize) bool {
        var x: usize = 0;
        var marked: bool = true;
        while (x < 5) : (x += 1) {
            marked = marked and self.marked[row][x];
        }
        return marked;
    }

    fn col_marked(self: *const Self, col: usize) bool {
        var y: usize = 0;
        var marked: bool = true;
        while (y < 5) : (y += 1) {
            marked = marked and self.marked[y][col];
        }
        return marked;
    }

    fn unmarked_sum(self: *const Self) i32 {
        var sum: i32 = 0;
        for (self.marked) |row, y| {
            for (row) |cell, x| {
                if (!cell) {
                    sum += self.grid[y][x];
                }
            }
        }
        return sum;
    }
};

pub fn part1(input: []const u8) i32 {
    var inp = std.mem.trimRight(u8, input, "\n");
    var lines = std.mem.split(u8, inp, "\n");
    var calls = std.mem.tokenize(u8, lines.next().?, ",");

    var boards = std.ArrayList(Board).init(std.heap.page_allocator);
    defer boards.deinit();

    while (lines.next()) |_| {
        var board = Board.init();

        var y: usize = 0;
        while (y < 5) : (y += 1) {
            const row = lines.next().?;
            var cols = std.mem.tokenize(u8, row, " ");
            var x: usize = 0;
            while (x < 5) : (x += 1) {
                board.grid[y][x] = util.parseInt(cols.next().?);
            }
        }

        boards.append(board) catch unreachable;
    }

    while (calls.next()) |call| {
        const call_num = util.parseInt(call);
        for (boards.items) |*board| {
            if (board.mark(call_num)) |sum| {
                return sum * call_num;
            }
        }
    }

    unreachable;
}

pub fn part2(input: []const u8) i32 {
    var inp = std.mem.trimRight(u8, input, "\n");
    var lines = std.mem.split(u8, inp, "\n");
    var calls = std.mem.tokenize(u8, lines.next().?, ",");

    var boards = std.ArrayList(Board).init(std.heap.page_allocator);
    defer boards.deinit();

    while (lines.next()) |_| {
        var board = Board.init();

        var y: usize = 0;
        while (y < 5) : (y += 1) {
            const row = lines.next().?;
            var cols = std.mem.tokenize(u8, row, " ");
            var x: usize = 0;
            while (x < 5) : (x += 1) {
                board.grid[y][x] = util.parseInt(cols.next().?);
            }
        }

        boards.append(board) catch unreachable;
    }

    while (calls.next()) |call| {
        const call_num = util.parseInt(call);
        var boards_left: usize = 0;
        var last_board_sum: ?i32 = null;
        for (boards.items) |*board| {
            if (board.done) continue;
            boards_left += 1;
            if (board.mark(call_num)) |sum| {
                last_board_sum = sum;
            }
        }
        if (boards_left == 1) {
            if (last_board_sum) |sum| {
                return sum * call_num;
            }
        }
    }

    unreachable;
}

test "day 4 part 1" {
    const test_input =
        \\7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
        \\
        \\22 13 17 11  0
        \\ 8  2 23  4 24
        \\21  9 14 16  7
        \\ 6 10  3 18  5
        \\ 1 12 20 15 19
        \\
        \\ 3 15  0  2 22
        \\ 9 18 13 17  5
        \\19  8  7 25 23
        \\20 11 10 24  4
        \\14 21 16 12  6
        \\
        \\14 21 17 24  4
        \\10 16 15  9 19
        \\18  8 23 26 20
        \\22 11 13  6  5
        \\ 2  0 12  3  7
    ;
    try std.testing.expectEqual(part1(test_input), 4512);
}

test "day 4 part 2" {
    const test_input =
        \\7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
        \\
        \\22 13 17 11  0
        \\ 8  2 23  4 24
        \\21  9 14 16  7
        \\ 6 10  3 18  5
        \\ 1 12 20 15 19
        \\
        \\ 3 15  0  2 22
        \\ 9 18 13 17  5
        \\19  8  7 25 23
        \\20 11 10 24  4
        \\14 21 16 12  6
        \\
        \\14 21 17 24  4
        \\10 16 15  9 19
        \\18  8 23 26 20
        \\22 11 13  6  5
        \\ 2  0 12  3  7
    ;
    try std.testing.expectEqual(part2(test_input), 1924);
}
