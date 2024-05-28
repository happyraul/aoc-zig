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

    var buf: [1024]u8 = undefined;
    var area: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var box = try Box.init(line);
        std.debug.print("{s} {d}+{d}={d}, sum: {d}\n", .{ line, box.surfaceArea(), box.slackArea(), box.wrappingArea(), area });
        area += box.wrappingArea();
    }

    try stdout.print("day 2: {d}\n", .{area});

    try bw.flush();
}

pub const Box = struct {
    l: u5,
    w: u5,
    h: u5,

    pub fn init(dimensions: []const u8) !Box {
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

    fn surfaceArea(box: Box) u16 {
        const l = @as(u16, box.l);
        const w = @as(u16, box.w);
        const h = @as(u16, box.h);

        return 2 * (l * w + l * h + w * h);
    }

    fn slackArea(box: Box) u16 {
        const l = @as(u16, box.l);
        const w = @as(u16, box.w);
        const h = @as(u16, box.h);

        if (box.l > box.w and box.l > box.h) {
            return w * h;
        } else if (box.w > box.l and box.w > box.h) {
            return l * h;
        } else { // height is the biggest
            return l * w;
        }
    }

    fn wrappingArea(box: Box) u16 {
        return box.surfaceArea() + box.slackArea();
    }
};
