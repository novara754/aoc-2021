const std = @import("std");
const util = @import("util");

const Wire = enum(u8) {
    a = 1 << 0,
    b = 1 << 1,
    c = 1 << 2,
    d = 1 << 3,
    e = 1 << 4,
    f = 1 << 5,
    g = 1 << 6,

    const Self = @This();

    fn fromString(wires: []const u8) u8 {
        var res: u8 = 0;
        for (wires) |wire| {
            res |= @enumToInt(std.meta.stringToEnum(Self, &[_]u8{wire}).?);
        }
        return res;
    }

    fn toString(wires: u8, out: []u8) void {
        for ("abcdefg") |wire, i| {
            const mask = @enumToInt(std.meta.stringToEnum(Self, &[_]u8{wire}).?);
            if ((wires & mask) > 0) {
                out[i] = wire;
            } else {
                out[i] = 0;
            }
        }
    }
};

fn isUniqueSignal(num: usize) bool {
    return num == 2 or num == 3 or num == 4 or num == 7;
}

pub fn part1(input: []const u8) !u64 {
    var count: u64 = 0;

    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " | ");
        _ = parts.next().?;
        var outputs = std.mem.split(u8, parts.next().?, " ");

        while (outputs.next()) |output| {
            if (isUniqueSignal(output.len)) {
                count += 1;
            }
        }
    }

    return count;
}

pub fn part2(input: []const u8) !u64 {
    const alloc = std.heap.page_allocator;

    var total: u64 = 0;

    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " | ");
        var inputs = std.mem.split(u8, parts.next().?, " ");
        var outputs = std.mem.split(u8, parts.next().?, " ");

        var wire_to_segment = std.AutoHashMap(Wire, Wire).init(alloc);
        defer wire_to_segment.deinit();

        var remaining_signals = std.ArrayList(u8).init(alloc);
        defer remaining_signals.deinit();

        var pattern_to_digit = std.AutoHashMap(u8, u8).init(alloc);
        defer pattern_to_digit.deinit();

        var digit_to_pattern = std.AutoHashMap(u8, u8).init(alloc);
        defer digit_to_pattern.deinit();

        while (inputs.next()) |signals| {
            // 0 - six segments, abcefg
            // 1 - two segments, cv
            // 2 - five segments, acdeg
            // 3 - five segments, acdfg
            // 4 - four segments, bcdf
            // 5 - five segments, abdfg
            // 6 - six segments, abdefg
            // 7 - three segments, acf
            // 8 - seven segments, abcdefg
            // 9 - six segments, abcdfg

            const pattern = Wire.fromString(signals);

            if (isUniqueSignal(signals.len)) {
                const digit: u8 = switch (signals.len) {
                    2 => 1,
                    3 => 7,
                    4 => 4,
                    7 => 8,
                    else => unreachable,
                };
                try pattern_to_digit.put(pattern, digit);
                try digit_to_pattern.put(digit, pattern);
            } else {
                try remaining_signals.append(pattern);
            }
        }

        const one = digit_to_pattern.get(1).?;
        const four = digit_to_pattern.get(4).?;

        while (remaining_signals.items.len > 0) {
            const pattern = remaining_signals.orderedRemove(0);
            const six = digit_to_pattern.get(6);

            if (@popCount(u8, pattern) == 5) {
                // We need to know the pattern for six to
                // correctly identify the following patterns.
                // If we dont have the pattern for six yet move
                // this pattern back to the end.
                if (six == null) {
                    try remaining_signals.append(pattern);
                    continue;
                }

                // Test if pattern represents a three
                if ((pattern & one) == one) {
                    try digit_to_pattern.put(3, pattern);
                    try pattern_to_digit.put(pattern, 3);
                }
                // Test if pattern is a five
                else if ((pattern & six.?) == pattern) {
                    try digit_to_pattern.put(5, pattern);
                    try pattern_to_digit.put(pattern, 5);
                }
                // Otherwise it's a two
                else {
                    try digit_to_pattern.put(2, pattern);
                    try pattern_to_digit.put(pattern, 2);
                }
            } else if (@popCount(u8, pattern) == 6) {
                // Test if pattern represent a six
                if (@popCount(u8, pattern & one) == 1) {
                    try digit_to_pattern.put(6, pattern);
                    try pattern_to_digit.put(pattern, 6);
                }
                // Test if pattern represent a nine
                else if ((pattern & four) == four) {
                    try digit_to_pattern.put(9, pattern);
                    try pattern_to_digit.put(pattern, 9);
                }
                // Otherwise it's a zero
                else {
                    try digit_to_pattern.put(0, pattern);
                    try pattern_to_digit.put(pattern, 0);
                }
            }
        }

        var i: u64 = 10000;
        while (outputs.next()) |output| {
            i = @divExact(i, 10);
            const pattern = Wire.fromString(output);
            const digit = pattern_to_digit.get(pattern).?;
            total += i * digit;
        }
    }

    return total;
}

test "day 8 part 1" {
    const test_input =
        \\be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        \\edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        \\fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        \\fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        \\aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        \\fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        \\dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        \\bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        \\egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        \\gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    ;
    try std.testing.expectEqual(part1(test_input), 26);
}

test "day 8 part 2" {
    const test_input =
        \\be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        \\edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        \\fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        \\fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        \\aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        \\fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        \\dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        \\bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        \\egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        \\gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    ;
    try std.testing.expectEqual(part2(test_input), 61229);
}
