const std = @import("std");
const fs = std.fs;
const heap = std.heap;
const io = std.io;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var file = try fs.cwd().openFile("input-01-1.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var open: i16 = 0;
    var close: i16 = 0;

    for (try in_stream.readAllAlloc(allocator, 7001), 1..) |char, index| {
        try stdout.print("{d}: {c}\n", .{ index, char });
        if (char == '(') open += 1;
        if (char == ')') close += 1;
    }

    try stdout.print("{d}", .{open - close});

    try bw.flush(); // don't forget to flush!
}
