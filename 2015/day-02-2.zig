const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const mem = std.mem;

pub fn main() !void {
    var file = try fs.cwd().openFile("input-02.txt", .{});
    defer file.close();

    var br = io.bufferedReader(file.reader());
    var in_stream = br.reader();

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var buf: [9]u8 = undefined;
    var area: u22 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var box = try Box.init(line);
        std.debug.print("{s} {d}+{d}={d}, sum: {d}\n", .{ line, box.wrapDistance(), box.volume(), box.ribbonLength(), area });
        area += box.ribbonLength();
    }

    try stdout.print("day 2: {d}\n", .{area});

    try bw.flush();
}

pub const Box = struct {
    l: u5,
    w: u5,
    h: u5,

    fn init(dimensions: []const u8) !Box {
        var it = mem.splitScalar(u8, dimensions, 'x');

        const l = try fmt.parseInt(u5, it.next().?, 10);
        const w = try fmt.parseInt(u5, it.next().?, 10);
        const h = try fmt.parseInt(u5, it.next().?, 10);

        return Box{
            .l = l,
            .w = w,
            .h = h,
        };
    }

    fn volume(box: Box) u15 {
        const l = @as(u15, box.l);
        const w = @as(u15, box.w);
        const h = @as(u15, box.h);

        return l * w * h;
    }

    fn wrapDistance(box: Box) u7 {
        const l = @as(u7, box.l);
        const w = @as(u7, box.w);
        const h = @as(u7, box.h);

        if (l > w and l > h) {
            return 2 * (w + h);
        } else if (w >= l and w > h) {
            return 2 * (l + h);
        } else { // height is the biggest
            return 2 * (l + w);
        }
    }

    fn ribbonLength(box: Box) u15 {
        return box.wrapDistance() + box.volume();
    }
};
