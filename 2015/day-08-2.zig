const std = @import("std");
const fs = std.fs;
const fmt = std.fmt;
const io = std.io;
const mem = std.mem;
const heap = std.heap;

const stdout_file = io.getStdOut().writer();
var bw = io.bufferedWriter(stdout_file);
const stdout = bw.writer();

pub fn main() !void {
    var file = try fs.cwd().openFile("input-08.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();
    var buf: [50]u8 = undefined;

    var code_total: u64 = 0;
    var encoded_total: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var idx: u8 = 0;
        var encoded_len: u64 = line.len + 2;
        while (idx < line.len) {
            switch (line[idx]) {
                '"' => encoded_len += 1,
                '\\' => encoded_len += 1,
                else => {},
            }
            idx += 1;
        }
        code_total += line.len;
        encoded_total += encoded_len;
    }

    try stdout.print("day 8: {d}\n", .{encoded_total - code_total});

    try bw.flush();
}
