const std = @import("std");
const util = @import("util.zig");

fn getMatchingClosing(c: u8) u8 {
    return switch (c) {
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>',
        else => unreachable,
    };
}

fn getErrorScore(c: u8) u64 {
    return switch (c) {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
        else => unreachable,
    };
}

fn getCompletionScore(c: u8) u64 {
    return switch (c) {
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4,
        else => unreachable,
    };
}

pub fn part1(input: []const u8) !u64 {
    var total_score: u64 = 0;
    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var stack = std.ArrayList(u8).init(std.heap.page_allocator);
        defer stack.deinit();

        for (line) |c| {
            switch (c) {
                '(', '[', '{', '<' => {
                    try stack.append(c);
                },
                ')', ']', '}', '>' => {
                    const last_opening = stack.pop();
                    const expected_closing = getMatchingClosing(last_opening);
                    if (expected_closing != c) {
                        total_score += getErrorScore(c);
                    }
                },
                else => unreachable,
            }
        }
    }

    return total_score;
}

pub fn part2(input: []const u8) !u64 {
    var scores = std.ArrayList(u64).init(std.heap.page_allocator);
    defer scores.deinit();

    var lines = std.mem.tokenize(u8, input, "\n");
    outer: while (lines.next()) |line| {
        var stack = std.ArrayList(u8).init(std.heap.page_allocator);
        defer stack.deinit();

        var total_score: u64 = 0;
        for (line) |c| {
            switch (c) {
                '(', '[', '{', '<' => {
                    try stack.append(c);
                },
                ')', ']', '}', '>' => {
                    const last_opening = stack.pop();
                    const expected_closing = getMatchingClosing(last_opening);
                    if (expected_closing != c) {
                        continue :outer;
                    }
                },
                else => unreachable,
            }
        }

        while (stack.popOrNull()) |c| {
            const closing = getMatchingClosing(c);
            total_score = total_score * 5 + getCompletionScore(closing);
        }

        try scores.append(total_score);
    }

    std.sort.sort(u64, scores.items, {}, comptime std.sort.asc(u64));
    const middle = @divFloor(scores.items.len, 2);
    return scores.items[middle];
}

test "day 10 part 1" {
    const test_input =
        \\[({(<(())[]>[[{[]{<()<>>
        \\[(()[<>])]({[<{<<[]>>(
        \\{([(<{}[<>[]}>{[]{[(<()>
        \\(((({<>}<{<{<>}{[]{[]{}
        \\[[<[([]))<([[{}[[()]]]
        \\[{[{({}]{}}([{[{{{}}([]
        \\{<[[]]>}<{[{[{[]{()[[[]
        \\[<(<(<(<{}))><([]([]()
        \\<{([([[(<>()){}]>(<<{{
        \\<{([{{}}[<[[[<>{}]]]>[]]
    ;
    try std.testing.expectEqual(part1(test_input), 26397);
}

test "day 10 part 2" {
    const test_input =
        \\[({(<(())[]>[[{[]{<()<>>
        \\[(()[<>])]({[<{<<[]>>(
        \\{([(<{}[<>[]}>{[]{[(<()>
        \\(((({<>}<{<{<>}{[]{[]{}
        \\[[<[([]))<([[{}[[()]]]
        \\[{[{({}]{}}([{[{{{}}([]
        \\{<[[]]>}<{[{[{[]{()[[[]
        \\[<(<(<(<{}))><([]([]()
        \\<{([([[(<>()){}]>(<<{{
        \\<{([{{}}[<[[[<>{}]]]>[]]
    ;
    try std.testing.expectEqual(part2(test_input), 288957);
}
