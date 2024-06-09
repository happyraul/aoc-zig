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
    var mem_total: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var idx: u8 = 0;
        var mem_len: usize = line.len - 2;
        while (idx < line.len) {
            if (line[idx] == '\\') {
                switch (line[idx + 1]) {
                    '\\' => {
                        mem_len -= 1;
                        idx += 1;
                    },
                    '"' => {
                        mem_len -= 1;
                        idx += 1;
                    },
                    'x' => {
                        mem_len -= 3;
                        idx += 3;
                    },
                    else => {},
                }
            }
            idx += 1;
        }
        //try stdout.print("{d} {s}\n", .{ line.len, line });
        code_total += line.len;
        mem_total += mem_len;
    }

    try stdout.print("day 8: {d}\n", .{code_total - mem_total});

    try bw.flush();
}
