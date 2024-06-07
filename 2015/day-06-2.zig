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
    var brightness_values: [size]@Vector(size, u6) = undefined;
    for (brightness_values, 0..) |_, idx| {
        brightness_values[idx] = @splat(0);
    }

    var buf: [33]u8 = undefined;
    var instruction: Instruction = undefined;
    var mask: @Vector(size, u2) = undefined;
    var positive_mask: @Vector(size, u2) = undefined;
    var positives: @Vector(size, bool) = undefined;
    const zero: @Vector(size, i1) = @splat(0);

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        instruction = try Instruction.init(line);
        mask = instruction.getMask();
        for (instruction.y1..instruction.y2 + 1) |row| {
            if (mem.eql(u8, instruction.action, "off")) {
                positives = getPositives(brightness_values[row]);
                positive_mask = @select(u2, positives, mask, zero);
                brightness_values[row] -= positive_mask;
            } else {
                brightness_values[row] += mask;
            }
        }
        try stdout.print("{s}\n", .{line});
        //try printCount(brightness_values);
    }

    try printCount(brightness_values);
    try stdout.print("day 6: \n", .{});

    try bw.flush();
}

fn getPositives(brightness_values: @Vector(size, i7)) @Vector(size, bool) {
    const zero: @Vector(size, i1) = @splat(0);
    return brightness_values > zero;
}

fn printCount(brightness_values: [size]@Vector(size, u6)) !void {
    var sum: u32 = 0;
    var counter: @Vector(1001, u32) = undefined;
    for (brightness_values, 0..) |_, idx| {
        counter = brightness_values[idx];
        sum += @reduce(.Add, counter);
    }
    try stdout.print("{d}\n", .{sum});
}

fn printBrightness(brightness: @Vector(size, i7)) !void {
    const row: [size]i7 = brightness;
    for (row) |val| {
        try stdout.print("{d}", .{val});
    }
    try stdout.print("\n", .{});
}

fn printLights(lights: [size]@Vector(size, i10)) !void {
    for (lights, 0..) |vec, row_num| {
        const row: [size]i10 = vec;
        try stdout.print("{d} ", .{row_num});
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

    fn getMask(self: Instruction) @Vector(size, u2) {
        var mask: @Vector(size, u1) = undefined;
        var mask_int: u1001 = undefined;

        const endX: u10 = self.x2 + 1;
        const mask_size: u10 = endX - self.x1;

        mask_int = math.pow(u1001, 2, mask_size) - 1 << @truncate(size - mask_size - (size - endX));
        mask = @bitCast(mask_int);

        var brightness: u2 = undefined;
        if (mem.eql(u8, self.action, "toggle")) {
            brightness = 2;
        } else {
            brightness = 1;
        }

        const result: @Vector(size, u2) = @splat(brightness);
        return result * mask;
    }
};
