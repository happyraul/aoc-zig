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

    //var buf: [4096]u8 = undefined;

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Day 1.1\n", .{});

    for (try in_stream.readAllAlloc(allocator, 128)) |char| {
        try stdout.print("{d}\n", .{char});
    }
    

    try bw.flush(); // don't forget to flush!
}
