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
    try part2(data);
}

fn part1(input: []const u8) void {
    var rucksacks = split(u8, input, "\n");

    var sum: u32 = 0;

    while (rucksacks.next()) |rucksack| {
        const left_compartment = rucksack[0 .. rucksack.len / 2];
        const right_compartment = rucksack[rucksack.len / 2 .. rucksack.len];

        print("Rucksack: {s}\n", .{rucksack});
        print("left: {s}\n", .{left_compartment});
        print("right: {s}\n", .{right_compartment});

        blk: for (left_compartment) |left| {
            for (right_compartment) |right| {
                if (left == right) {
                    // item is in both rucksacks, add to list

                    print("Found: {s}\n", .{[_]u8{left}});

                    // Convert to priorities;
                    switch (left) {
                        'a'...'z' => sum += left - 96,
                        'A'...'Z' => sum += left - 38,
                        else => unreachable,
                    }

                    break :blk;
                }
            }
        }

        print("Continuing...\n", .{});
    }

    print("Part 1: {}\n", .{sum});
}

fn part2(input: []const u8) !void {
    var it = split(u8, input, "\n");

    var sum: u32 = 0;

    var rucksacks = std.ArrayList([]const u8).init(std.heap.page_allocator);
    while (it.next()) |rucksack| try rucksacks.append(rucksack);
    defer rucksacks.deinit();

    var i: u32 = 0;
    while (i < rucksacks.items.len) : (i += 3) {
        if (i + 2 >= rucksacks.items.len) continue;

        const left_rucksack = rucksacks.items[i];

        const middle_rucksack = rucksacks.items[i + 1];
        const right_rucksack = rucksacks.items[i + 2];

        blk: for (left_rucksack) |left| {
            for (middle_rucksack) |middle| {
                for (right_rucksack) |right| {
                    if (left == middle and middle == right) {
                        // We've found the bage

                        print("Found: {s}\n", .{[_]u8{left}});

                        // Convert to priorities;
                        switch (left) {
                            'a'...'z' => sum += left - 96,
                            'A'...'Z' => sum += left - 38,
                            else => unreachable,
                        }

                        break :blk;
                    }
                }
            }
        }
    }

    print("Part 2: {}\n", .{sum});
}

const Context = struct {};

fn lessThan(_: Context, left: u8, right: u8) bool {
    return left < right;
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
