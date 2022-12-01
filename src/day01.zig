const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const example =
    \\1000
    \\2000
    \\3000
    \\
    \\4000
    \\
    \\5000
    \\6000
    \\
    \\7000
    \\8000
    \\9000
    \\
    \\10000
;

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

pub fn main() !void {
    const elves = try top3(data);

    print("Part 1: {}\n", .{elves[0].?.calories});
    print("Part 2: {}\n", .{elves[0].?.calories + elves[1].?.calories + elves[2].?.calories});
}

const Elf = struct { id: usize, calories: u64 };

fn top3(input: []const u8) ![3]?Elf {
    var elves = split(u8, input, "\n\n");

    var top_elves: [3]?Elf = .{ null, null, null };

    var i: u32 = 0;
    while (elves.next()) |items_str| : (i += 1) {
        var foodstuffs = split(u8, trim(u8, items_str, " \n"), "\n");
        var total_calories: u32 = 0;

        while (foodstuffs.next()) |calories| {
            total_calories += try parseInt(u32, calories, 10);
        }

        for (top_elves) |*maybe_elf, j| {
            if (maybe_elf.*) |elf| {
                if (total_calories > elf.calories) {
                    // Shift current elf struct down one position in the list
                    if (j + 1 < top_elves.len) top_elves[j + 1] = elf;

                    maybe_elf.* = .{ .id = i, .calories = total_calories };
                    break;
                }
            } else {
                maybe_elf.* = .{ .id = i, .calories = total_calories };
                break;
            }
        }
    }

    return top_elves;
}
