const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

const example =
    \\A Y
    \\B X
    \\C Z
;

const Action = enum(u32) { Rock = 1, Paper = 2, Scissors = 3 };
const Result = enum(u32) { Loss = 0, Draw = 3, Win = 6 };

pub fn main() !void {
    // part1(data);

    var rounds = split(u8, data, "\n");
    var part1_ans: u32 = 0;
    var part2_ans: u32 = 0;

    while (rounds.next()) |_round| {
        const round = trim(u8, _round, &std.ascii.whitespace);
        if (round.len == 0) continue; // some lines are blank

        const opponent = round[0]; // Opponent Move
        const player = round[2]; // Player Move

        part1_ans += part1(player, opponent);
        part2_ans += part2(player, opponent);
    }

    print("Part 1: {}\n", .{part1_ans});
    print("Part 2: {}\n", .{part2_ans});
}

fn part1(player: u8, opponent: u8) u32 {
    const lut: [3]Result = .{ .Win, .Loss, .Draw };
    const diff = player - opponent;

    return @enumToInt(lut[diff % 3]) + player - ('X' - 1);
}

fn part2(player: u8, opponent: u8) u32 {
    const lut: [3]Action = .{ .Scissors, .Rock, .Paper };

    return @enumToInt(lut[(player + opponent) % 3]) + 3 * (player - 'X');
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
