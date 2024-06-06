const std = @import("std");
const fs = std.fs;
const fmt = std.fmt;
const io = std.io;
const mem = std.mem;
const simd = std.simd;
const math = std.math;

const stdout_file = io.getStdOut().writer();
var bw = io.bufferedWriter(stdout_file);
const stdout = bw.writer();

const size: u10 = 1001;

pub fn main() !void {
    var file = try fs.cwd().openFile("input-06.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();

    // initialize
    var lights: [size]@Vector(size, u1) = undefined;
    for (lights, 0..) |_, idx| {
        lights[idx] = @splat(0);
    }

    var buf: [33]u8 = undefined;
    var instruction: Instruction = undefined;
    var mask: @Vector(size, u1) = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        instruction = try Instruction.init(line);
        mask = instruction.getMask();
        for (instruction.y1..instruction.y2 + 1) |row| {
            if (mem.eql(u8, instruction.action, "on")) {
                lights[row] |= mask;
            } else if (mem.eql(u8, instruction.action, "off")) {
                lights[row] &= ~mask;
            } else {
                lights[row] ^= mask;
            }
        }
        try stdout.print("{s}\n", .{line});
    }

    var sum: u32 = 0;
    var counter: @Vector(1001, u10) = undefined;
    for (lights, 0..) |_, idx| {
        counter = lights[idx];
        sum += @reduce(.Add, counter);
    }
    try stdout.print("day 6: {d}\n", .{sum});

    try bw.flush();
}

fn printLights(lights: [size]@Vector(size, u1)) !void {
    for (lights, 0..) |vec, row_num| {
        const row: [size]u1 = vec;
        try stdout.print("{000d} ", .{row_num});
        for (row) |light| {
            try stdout.print("{d}", .{light});
        }
        try stdout.print("\n", .{});
    }
}

const Instruction = struct {
    action: []const u8,
    x1: u10,
    y1: u10,
    x2: u10,
    y2: u10,

    fn init(line: []const u8) !Instruction {
        var action: []const u8 = undefined;
        var it = mem.splitScalar(u8, line, ' ');

        if (mem.eql(u8, it.next().?, "turn")) {
            action = it.next().?;
        } else {
            action = "toggle";
        }

        var coord = mem.splitScalar(u8, it.next().?, ',');
        const x1 = try fmt.parseInt(u10, coord.next().?, 10);
        const y1 = try fmt.parseInt(u10, coord.next().?, 10);

        _ = it.next();

        coord = mem.splitScalar(u8, it.next().?, ',');
        const x2 = try fmt.parseInt(u10, coord.next().?, 10);
        const y2 = try fmt.parseInt(u10, coord.next().?, 10);

        return Instruction{
            .action = action,
            .x1 = x1,
            .y1 = y1,
            .x2 = x2,
            .y2 = y2,
        };
    }

    fn getMask(self: Instruction) @Vector(size, u1) {
        var mask: @Vector(size, u1) = undefined;
        var mask_int: u1001 = undefined;

        const endX: u10 = self.x2 + 1;
        const mask_size: u10 = endX - self.x1;

        mask_int = math.pow(u1001, 2, mask_size) - 1 << @truncate(size - mask_size - (size - endX));
        mask = @bitCast(mask_int);
        return mask;
    }
};
