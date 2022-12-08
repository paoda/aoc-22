const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
// const gpa = util.gpa;

const data = @embedFile("data/day07.txt");
const example =
    \\$ cd /
    \\$ ls
    \\dir a
    \\14848514 b.txt
    \\8504156 c.dat
    \\dir d
    \\$ cd a
    \\$ ls
    \\dir e
    \\29116 f
    \\2557 g
    \\62596 h.lst
    \\$ cd e
    \\$ ls
    \\584 i
    \\$ cd ..
    \\$ cd ..
    \\$ cd d
    \\$ ls
    \\4060174 j
    \\8033020 d.log
    \\5626152 d.ext
    \\7214296 k
;

const Node = struct {
    const Self = @This();

    path: []const u8,
    size: ?usize,
    children: std.ArrayListUnmanaged(Node),

    pub fn init(path: []const u8, size: ?usize) Self {
        return .{
            .path = path,
            .size = size,
            .children = std.ArrayListUnmanaged(Node){},
        };
    }

    fn deinit(self: *Self, allocator: Allocator) void {
        for (self.children.items) |*child| child.deinit(allocator);
        self.children.deinit(allocator);

        self.* = undefined;
    }

    fn addChild(self: *Self, allocator: Allocator, child: Self) !void {
        try self.children.append(allocator, child);
    }

    fn print(self: *const Self) void {
        std.debug.print("{s} | Size: {?}\n", .{ self.path, self.size });

        for (self.children.items) |child| {
            std.debug.print("{s}/", .{std.mem.trim(u8, self.path, "/")});
            child.print();
        }
    }

    fn find(self: *Self, path: []const u8) ?*Self {
        if (std.mem.eql(u8, self.path, path)) return self;

        for (self.children.items) |*child| {
            return child.find(path) orelse continue;
        }

        return null;
    }
};

const Tree = struct {
    const Self = @This();

    root: Node,
    allocator: Allocator,

    pub fn init(allocator: Allocator) Self {
        return .{
            .root = Node.init("/", null),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.root.deinit(self.allocator);
        self.* = undefined;
    }

    fn find(self: *Self, path: []const u8) ?*Node {
        return self.root.find(path);
    }

    fn print(self: *Self) void {
        self.root.print();
    }
};

const State = enum {
    Ready, // Expect $ to denote user input
    Command, // ls or cd
    List,
    ChangeDirectory,
};

pub fn main() !void {
    try part1(example);
}

fn part1(input: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());

    const allocator = gpa.allocator();

    var lines = tokenize(u8, input, "\n");
    var state: State = .Ready;

    var tree = Tree.init(allocator);
    defer tree.deinit();

    var current_directory: ?*Node = null;

    while (lines.next()) |line| {
        var tokens = tokenize(u8, line, " ");

        while (tokens.next()) |token| {
            switch (state) {
                .Ready => switch (token[0]) {
                    '$' => state = .Command,
                    else => std.debug.panic("expected '$', received: {s}", .{line}),
                },
                .Command => switch (token[0]) {
                    'c' => state = .ChangeDirectory,
                    'l' => state = .List,
                    else => std.debug.panic("expected 'cd' or 'ls', received: {s}", .{token}),
                },
                .ChangeDirectory => {
                    const current = current_directory orelse &tree.root;
                    current_directory = current.find(token);

                    state = .Ready;
                },
                .List => switch (token[0]) {
                    '$' => state = .Command, // See .Ready switch prong
                    'd' => {
                        const dir_name = tokens.next() orelse @panic("expected directory name");
                        const current = current_directory.?;

                        if (current.find(dir_name) == null) try current.addChild(allocator, Node.init(dir_name, null));
                    },
                    '0'...'9' => {
                        const file_size = parseInt(u32, token, 10) catch unreachable;
                        const file_path = tokens.next() orelse @panic("expected file name");

                        try current_directory.?.addChild(allocator, Node.init(file_path, file_size));
                    },
                    else => std.debug.panic("unexpected value {s} when parsing file list", .{line}),
                },
            }
        }
    }

    tree.print();
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
