const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");
const example =
    \\2-4,6-8
    \\2-3,4-5
    \\5-7,7-9
    \\2-8,3-7
    \\6-6,4-6
    \\2-6,4-8
;

pub fn main() !void {
    var pairs = split(u8, data, "\n");

    var part1_count: u32 = 0;
    var part2_count: u32 = 0;

    while (pairs.next()) |_pair| {
        const pair = trim(u8, _pair, &std.ascii.whitespace);
        if (pair.len == 0) continue;

        var ranges = split(u8, pair, ",");

        const left_range = ranges.next().?;
        const right_range = ranges.next().?;

        var left_digits = split(u8, left_range, "-");
        var right_digits = split(u8, right_range, "-");

        const left_min = parseInt(u32, left_digits.next().?, 10) catch @panic("failed to parse min left int");
        const left_max = parseInt(u32, left_digits.next().?, 10) catch @panic("failed to parse max left int");
        const right_min = parseInt(u32, right_digits.next().?, 10) catch @panic("failed to parse min right int");
        const right_max = parseInt(u32, right_digits.next().?, 10) catch @panic("failed to parse min right int");

        part1(&part1_count, left_min, left_max, right_min, right_max);
        part2(&part2_count, left_min, left_max, right_min, right_max);
    }

    print("Part 1: {}\n", .{part1_count});
    print("Part 2: {}\n", .{part2_count});
}

fn part1(count: *u32, left_min: u32, left_max: u32, right_min: u32, right_max: u32) void {
    const left_bitset = bitSet(left_min, left_max);
    const right_bitset = bitSet(right_min, right_max);

    if (left_bitset & right_bitset == left_bitset or left_bitset & right_bitset == right_bitset) count.* += 1;
}

fn part2(count: *u32, left_min: u32, left_max: u32, right_min: u32, right_max: u32) void {
    const left_bitset = bitSet(left_min, left_max);
    const right_bitset = bitSet(right_min, right_max);

    if ((left_bitset & right_bitset) != 0) count.* += 1;
}

fn bitSet(range_start: u32, range_end: u32) u100 {
    const Log2Int = std.math.Log2Int;

    var result: u100 = 0;
    var i: Log2Int(u100) = @intCast(Log2Int(u100), range_start);

    while (i <= range_end) : (i += 1) {
        result |= @as(u100, 1) << i;
    }

    return result;
}
// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
