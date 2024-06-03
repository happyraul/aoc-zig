const std = @import("std");
const fs = std.fs;
const io = std.io;
const mem = std.mem;

pub fn main() !void {
    var file = try fs.cwd().openFile("input-05.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var buf: [17]u8 = undefined;
    var nice_count: u11 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (isNice(line)) {
            nice_count += 1;
        }
    }

    try stdout.print("day 5: {d}\n", .{nice_count});

    try bw.flush();
}

fn isNice(line: []const u8) bool {
    var sequences = mem.window(u8, line, 3, 1);
    var has_pair: bool = false;
    var has_sandwich: bool = false;
    var rest_idx: u5 = 2;

    while (sequences.next()) |chunk| {
        if (has_sandwich or chunk[0] == chunk[2]) {
            has_sandwich = true;
        }

        if (!has_pair and rest_idx < 15) {
            const rest: []const u8 = line[rest_idx..line.len];
            if (mem.indexOf(u8, rest, chunk[0..2])) |_| {
                has_pair = true;
            }
        }

        if (has_sandwich and has_pair) {
            break;
        }

        rest_idx += 1;
    }

    return has_sandwich and has_pair;
}
