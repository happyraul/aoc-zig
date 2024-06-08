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
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var file = try fs.cwd().openFile("input-07.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();
    var buf: [33]u8 = undefined;

    var circuit = std.StringHashMap([]const u8).init(allocator);
    var resolved = std.StringHashMap(u16).init(allocator);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = mem.splitSequence(u8, line, " -> ");
        const c: []const u8 = it.next().?;
        const i: []const u8 = it.next().?;

        const identifier = try allocator.alloc(u8, i.len);
        const connection = try allocator.alloc(u8, c.len);
        @memcpy(identifier, i);
        @memcpy(connection, c);

        try circuit.put(identifier, connection);
    }

    try stdout.print("resolve {s}: {d}\n", .{ "a", try resolve("a", circuit, &resolved) });

    try bw.flush();
}

fn resolve(identifier: []const u8, circuit: std.StringHashMap([]const u8), resolved: *std.StringHashMap(u16)) !u16 {
    if (resolved.*.get(identifier)) |r| {
        return r;
    }
    if (fmt.parseInt(u16, identifier, 10)) |parsed| {
        try resolved.*.put(identifier, parsed);
        return parsed;
    } else |_| {
        const connection: []const u8 = circuit.get(identifier).?;
        try bw.flush();
        if (fmt.parseInt(u16, connection, 10)) |parsed| {
            try resolved.*.put(identifier, parsed);
            return parsed;
        } else |err| switch (err) {
            error.InvalidCharacter => {
                var it = mem.splitScalar(u8, connection, ' ');
                const first: []const u8 = it.next().?;
                if (mem.eql(u8, first, "NOT")) {
                    const operand = it.next().?;
                    if (circuit.contains(operand)) {
                        const result = ~(try resolve(operand, circuit, resolved));
                        try resolved.*.put(identifier, result);
                        return result;
                    }
                } else {
                    if (it.next()) |operator| {
                        const second = it.next().?;

                        if (mem.eql(u8, operator, "RSHIFT")) {
                            const result = (try resolve(first, circuit, resolved)) >> try fmt.parseInt(u4, second, 10);
                            try resolved.*.put(identifier, result);
                            return result;
                        } else if (mem.eql(u8, operator, "LSHIFT")) {
                            const result = (try resolve(first, circuit, resolved)) << try fmt.parseInt(u4, second, 10);
                            try resolved.*.put(identifier, result);
                            return result;
                        } else if (mem.eql(u8, operator, "AND")) {
                            const result = (try resolve(first, circuit, resolved)) & (try resolve(second, circuit, resolved));
                            try resolved.*.put(identifier, result);
                            return result;
                        } else if (mem.eql(u8, operator, "OR")) {
                            const result = (try resolve(first, circuit, resolved)) | (try resolve(second, circuit, resolved));
                            try resolved.*.put(identifier, result);
                            return result;
                        }
                    } else { // ?
                        return try resolve(first, circuit, resolved);
                    }
                }
                return 0;
            },
            else => |other_err| return other_err,
        }
    }
}
