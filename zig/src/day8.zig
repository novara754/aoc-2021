const std = @import("std");
const util = @import("util");

fn signals_to_bits(signals: []const u8) u8 {
    var res: u8 = 0;
    for (signals) |signal| {
        res |= @as(u8, 1) << @intCast(u3, signal - 'a');
    }
    return res;
}

fn bits_to_signals(bits: u8, out: []u8) void {
    for (out) |*signal, i| {
        const bit = (bits >> @intCast(u3, i)) & 1;
        signal.* = if (bit == 1) ('a' + @intCast(u8, i)) else 0;
    }
}

fn is_unique_number(num: usize) bool {
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
            if (is_unique_number(output.len)) {
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
        // map each wire to list of segments (bitmask) it could connect to
        var wire_connections = std.AutoHashMap(u8, u8).init(alloc);
        defer wire_connections.deinit();

        // map each number to a list of wires (bitmask) belonging to it
        var number_wires = std.AutoHashMap(usize, u8).init(alloc);
        defer number_wires.deinit();

        var parts = std.mem.split(u8, line, " | ");
        var inputs = std.mem.split(u8, parts.next().?, " ");
        var outputs = parts.next().?;
        _ = outputs;

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
            const possible_segments = switch (signals.len) {
                // 1
                2 => comptime signals_to_bits("cf"),
                // 7
                3 => comptime signals_to_bits("acf"),
                // 4
                4 => comptime signals_to_bits("bcdf"),
                // 2, 3, 5
                5 => comptime signals_to_bits("abcdefg"),
                // 0, 6, 9
                6 => comptime signals_to_bits("abcdefg"),
                // 8
                7 => comptime signals_to_bits("abcdefg"),
                else => unreachable,
            };

            const mask = signals_to_bits(signals);

            if (is_unique_number(signals.len)) {
                try number_wires.put(signals.len, mask);
            }

            for (signals) |signal| {
                const res = try wire_connections.getOrPut(signal);
                if (res.found_existing) {
                    std.log.err("in {s}, found existing for {c}, comparing to {d}", .{ signals, signal, possible_segments });
                    res.value_ptr.* &= possible_segments;
                } else {
                    std.log.err("in {s}, found no existing for {c}, inserting {d}", .{ signals, signal, possible_segments });
                    res.value_ptr.* = mask;
                }
            }
        }

        for ("abcdefg") |wire| {
            var signals: [7]u8 = undefined;
            bits_to_signals(wire_connections.get(wire).?, signals[0..]);
            std.log.err("{c} -> {s}", .{ wire, signals });
        }

        // only look at the first line in the puzzle input
        break;
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
