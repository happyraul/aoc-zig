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

    var map = std.AutoHashMap(Position, u8).init(allocator);
    defer map.deinit();

    var currentPosition = Position{ .x = 0, .y = 0 };
    try map.put(currentPosition, 1);

    for (try in_stream.readAllAlloc(allocator, 8193)) |move| {
        switch (move) {
            '<' => currentPosition = Position{
                .x = currentPosition.x - 1,
                .y = currentPosition.y,
            },
            '>' => currentPosition = Position{
                .x = currentPosition.x + 1,
                .y = currentPosition.y,
            },
            '^' => currentPosition = Position{
                .x = currentPosition.x,
                .y = currentPosition.y + 1,
            },
            else => currentPosition = Position{
                .x = currentPosition.x,
                .y = currentPosition.y - 1,
            },
        }
        try map.put(currentPosition, 1);
    }

    try stdout.print("day 3: {d}\n", .{map.count()});

    try bw.flush();
}

const Position = struct { x: i8, y: i8 };
