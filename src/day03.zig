const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

const example =
    \\vJrwpWtwJgWrhcsFMMfFFhFp
    \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    \\PmmdzqPrVvPwwTWBwg
    \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    \\ttgJtRGJQctTZtZT
    \\CrZsJsPPZsGzwwsLwLmpwMDw
;

pub fn main() !void {
    part1(data);
    part2(data);
}

fn part1(input: []const u8) void {
    var rucksacks = split(u8, input, "\n");
    var sum: u64 = 0;

    while (rucksacks.next()) |rucksack| {
        const left_compartment = bitSet(rucksack[0 .. rucksack.len / 2]);
        const right_compartment = bitSet(rucksack[rucksack.len / 2 .. rucksack.len]);

        const overlapping = left_compartment & right_compartment;
        sum += if (overlapping != 0) std.math.log2_int(u64, overlapping) else 0;
    }

    print("Part 1: {}\n", .{sum});
}

fn part2(input: []const u8) void {
    var rucksacks = split(u8, input, "\n");
    var previous_bitset: u64 = 0;
    var sum: u64 = 0;

    var i: u32 = 0;
    while (rucksacks.next()) |rucksack| : (i += 1) {
        const bitset = bitSet(rucksack);

        if (i % 3 == 0) {
            sum += if (previous_bitset != 0) std.math.log2_int(u64, previous_bitset) else 0;
            previous_bitset = bitset;
        } else {
            previous_bitset &= bitset;
        }
    }

    print("Part 2: {}\n", .{sum});
}

fn bitSet(compartment: []const u8) u64 {
    var result: u64 = 0;

    for (compartment) |char| {
        const shift_amt = switch (char) {
            'a'...'z' => char - 96,
            'A'...'Z' => char - 38,
            else => unreachable,
        };

        result |= @as(u64, 1) << @intCast(u6, shift_amt);
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
