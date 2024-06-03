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
    var sequences = mem.window(u8, line, 2, 1);
    const bad_words = [4]*const [2:0]u8{ "ab", "cd", "pq", "xy" };
    const vowels = "aeiou";
    var has_double: bool = false;
    var vowel_count: u4 = 0;

    for (vowels) |vowel| {
        if (line[0] == vowel) {
            vowel_count += 1;
        }
    }

    while (sequences.next()) |bytes| {
        for (bad_words) |bad| {
            if (mem.eql(u8, bytes, bad)) {
                return false;
            }
        }
        if (has_double or bytes[0] == bytes[1]) {
            has_double = true;
        }

        if (vowel_count < 3) {
            for (vowels) |vowel| {
                if (bytes[1] == vowel) {
                    vowel_count += 1;
                }
            }
        }
    }

    return has_double and vowel_count > 2;
}
