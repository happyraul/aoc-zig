const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const mem = std.mem;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var file = try fs.cwd().openFile("input-03.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var map = std.AutoHashMap(Position, u1).init(allocator);
    defer map.deinit();

    var santaPosition = Position{ .x = 0, .y = 0 };
    var robotPosition = Position{ .x = 0, .y = 0 };
    try map.put(santaPosition, 1);

    for (try in_stream.readAllAlloc(allocator, 8193), 0..) |move, idx| {
        if (idx % 2 == 0) {
            switch (move) {
                '<' => santaPosition = Position{
                    .x = santaPosition.x - 1,
                    .y = santaPosition.y,
                },
                '>' => santaPosition = Position{
                    .x = santaPosition.x + 1,
                    .y = santaPosition.y,
                },
                '^' => santaPosition = Position{
                    .x = santaPosition.x,
                    .y = santaPosition.y + 1,
                },
                'v' => santaPosition = Position{
                    .x = santaPosition.x,
                    .y = santaPosition.y - 1,
                },
                else => {},
            }
            try map.put(santaPosition, 1);
        } else {
            switch (move) {
                '<' => robotPosition = Position{
                    .x = robotPosition.x - 1,
                    .y = robotPosition.y,
                },
                '>' => robotPosition = Position{
                    .x = robotPosition.x + 1,
                    .y = robotPosition.y,
                },
                '^' => robotPosition = Position{
                    .x = robotPosition.x,
                    .y = robotPosition.y + 1,
                },
                'v' => robotPosition = Position{
                    .x = robotPosition.x,
                    .y = robotPosition.y - 1,
                },
                else => {},
            }
            try map.put(robotPosition, 1);
        }

        try stdout.print("{d} {c} S({d}, {d}) R({d}, {d}) {d}\n", .{ idx, move, santaPosition.x, santaPosition.y, robotPosition.x, robotPosition.y, map.count() });
    }

    try stdout.print("day 3: {d}\n", .{map.count()});

    try bw.flush();
}

const Position = struct { x: i8, y: i8 };
