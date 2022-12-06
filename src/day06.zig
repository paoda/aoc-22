const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day06.txt");
const example = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg";

pub fn main() !void {
    print("Part 1: {any}\n", .{solve(data, 4)});
    print("Part 2: {any}\n", .{solve(data, 14)});
}

fn solve(input: []const u8, comptime count: u32) ?usize {
    var bitset: u32 = 0; // 26 bits used for the alphabet

    for (input) |char, i| {
        if (i >= count) {
            const to_remove = input[i - count];

            var can_delete: bool = true;
            for (input[i - (count - 1) .. i]) |prev| {
                if (prev == to_remove) can_delete = false;
            }

            if (can_delete) bitset &= ~(@as(u32, 1) << @intCast(u5, to_remove - 'a'));
        }

        bitset |= @as(u32, 1) << @intCast(u5, char - 'a');
        if (@popCount(bitset) == count) return i + 1;
    }

    return null;
}

test "mjqjpqmgbljsphdztnvjfqwrcgsmlb" {
    try std.testing.expectEqual(@as(?usize, 7), solve("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 4));
    try std.testing.expectEqual(@as(?usize, 19), solve("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 14));
}

test "bvwbjplbgvbhsrlpgdmjqwftvncz" {
    try std.testing.expectEqual(@as(?usize, 5), solve("bvwbjplbgvbhsrlpgdmjqwftvncz", 4));
    try std.testing.expectEqual(@as(?usize, 23), solve("bvwbjplbgvbhsrlpgdmjqwftvncz", 14));
}

test "nppdvjthqldpwncqszvftbrmjlhg" {
    try std.testing.expectEqual(@as(?usize, 6), solve("nppdvjthqldpwncqszvftbrmjlhg", 4));
    try std.testing.expectEqual(@as(?usize, 23), solve("nppdvjthqldpwncqszvftbrmjlhg", 14));
}

test "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" {
    try std.testing.expectEqual(@as(?usize, 10), solve("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 4));
    try std.testing.expectEqual(@as(?usize, 29), solve("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 14));
}

test "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" {
    try std.testing.expectEqual(@as(?usize, 11), solve("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 4));
    try std.testing.expectEqual(@as(?usize, 26), solve("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 14));
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
