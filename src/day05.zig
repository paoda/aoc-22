const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
// const gpa = util.gpa;

const data = @embedFile("data/day05.txt");

const example =
    \\    [D]    
    \\[N] [C]    
    \\[Z] [M] [P]
    \\ 1   2   3 
    \\
    \\move 1 from 2 to 1
    \\move 3 from 1 to 3
    \\move 2 from 2 to 1
    \\move 1 from 1 to 2
;

const Stack = std.ArrayList(u8);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());

    const allocator = gpa.allocator();

    var lines = tokenize(u8, data, "\n");

    var p1_stacks: ?[]Stack = null;
    defer if (p1_stacks) |stacks| {
        for (stacks) |stack| stack.deinit();
        allocator.free(stacks);
    };

    var p2_stacks: ?[]Stack = null;
    defer if (p2_stacks) |stacks| {
        for (stacks) |stack| stack.deinit();
        allocator.free(stacks);
    };

    while (lines.next()) |line| {
        if (p1_stacks == null) {
            const len = @floatToInt(u32, @ceil(@intToFloat(f32, line.len) / 4.0));

            var tmp = try allocator.alloc(Stack, len);
            for (tmp) |*stack| stack.* = Stack.init(allocator);
            p1_stacks = tmp;

            tmp = try allocator.alloc(Stack, len); // Later we Copy p1_stacks to p2_stacks
            p2_stacks = tmp;
        }

        if (line[1] == '1') break; // We're done processing the stack inital state

        var i: u32 = 0;
        while (i < line.len) : (i += 4) {
            if (line[i] == '[') try p1_stacks.?[i / 4].append(line[i..][1]);
        }
    }

    // The Stacks are actually backwards, so we need to reverse the order of their contents
    for (p1_stacks.?) |stack| std.mem.reverse(u8, stack.items);

    // Perform a Deep Copy for Part 2's set of Stacks
    for (p2_stacks.?) |*stack, i| stack.* = Stack.fromOwnedSlice(allocator, try allocator.dupe(u8, p1_stacks.?[i].items));

    while (lines.next()) |_line| {
        const line = trim(u8, _line, &std.ascii.whitespace);
        if (line.len == 0) continue;

        var words = tokenize(u8, line, " ");

        _ = words.next(); // "move"
        const count = try parseInt(u32, words.next().?, 10);
        _ = words.next(); // "from"
        const source = try parseInt(u32, words.next().?, 10);
        _ = words.next(); // "to"
        const dest = try parseInt(u32, words.next().?, 10);

        // Part 1
        try part1(p1_stacks.?, count, source, dest);

        // Part 2
        try part2(allocator, p2_stacks.?, count, source, dest);
    }

    print("Part 1: ", .{});
    for (p1_stacks.?) |*stack| print("{s}", .{[_]u8{stack.pop()}});
    print("\n", .{});

    print("Part 2: ", .{});
    for (p2_stacks.?) |*stack| print("{s}", .{[_]u8{stack.pop()}});
    print("\n", .{});
}

fn part1(stacks: []Stack, count: u32, src: u32, dst: u32) !void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const char = stacks[src - 1].pop();
        try stacks[dst - 1].append(char);
    }
}

fn part2(allocator: Allocator, stacks: []Stack, count: u32, src: u32, dst: u32) !void {
    const items = try allocator.alloc(u8, count);
    defer allocator.free(items);

    for (items) |*char| char.* = stacks[src - 1].pop();
    std.mem.reverse(u8, items);

    try stacks[dst - 1].appendSlice(items);
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
