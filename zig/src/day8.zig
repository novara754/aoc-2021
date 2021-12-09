const std = @import("std");
const util = @import("util");

const Wires = enum(u8) {
    a = 1 << 0,
    b = 1 << 1,
    c = 1 << 2,
    d = 1 << 3,
    e = 1 << 4,
    f = 1 << 5,
    g = 1 << 6,
};

fn signals_to_bits(signals: []u8) u8 {
    var res: u8 = 0;
    for (signals) |_, i| {
        std.meta.stringToEnum(signals[i..(i + 1)]);
    }
    return res;
}

pub fn part1(input: []const u8) !u64 {
    var count: u64 = 0;

    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " | ");
        _ = parts.next().?;
        var outputs = std.mem.split(u8, parts.next().?, " ");

        while (outputs.next()) |output| {
            if (output.len == 2 or output.len == 3 or output.len == 4 or output.len == 7) {
                count += 1;
            }
        }
    }

    return count;
}

pub fn part2(input: []const u8) !u64 {
    //const arena = std.heap.ArenaAllocator(std.heap.page_allocator);
    //const alloc = &arena.allocator;

    //var total: u64 = 0;

    //var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    //while (lines.next()) |line| {
    //    // map each number to a list of wires (bitmask) belonging to it
    //    var number_wires = std.AutoHashMap(u8, u8).init(alloc);
    //    defer number_wires.deinit();

    //    var parts = std.mem.split(u8, line, " | ");
    //    var inputs = std.mem.split(u8, parts.next().?, " ");
    //    var outputs = parts.next().?;
    //    _ = outputs;

    //    while (inputs.next()) |signals| {
    //        // 0 - six segments, abcefg
    //        // 1 - two segments, cv
    //        // 2 - five segments, acdeg
    //        // 3 - five segments, acdfg
    //        // 4 - four segments, bcdf
    //        // 5 - five segments, abdfg
    //        // 6 - six segments, abdefg
    //        // 7 - three segments, acf
    //        // 8 - seven segments, abcdefg
    //        // 9 - six segments, abcdfg
    //
    //
    //    }

    //    // only look at the first line in the puzzle input
    //    break;
    //}

    //return total;
    _ = input;
    return 0;
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
    try std.testing.expectEqual(part2(test_input), 0);
}
