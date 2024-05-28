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
        std.debug.print("{s} {d} {d}\n", .{line, box.wrappingArea(), area});
        area += box.wrappingArea();
    }

    try stdout.print("day 2: {d}", .{area});

    try bw.flush(); // don't forget to flush!
}

pub const Box = struct {
    l: u16,
    w: u16,
    h: u16,

    pub fn init(dimensions: []const u8) !Box {
        var it = mem.splitScalar(u8, dimensions, 'x');

        const l = try fmt.parseInt(u16, it.next().?, 10);
        const w = try fmt.parseInt(u16, it.next().?, 10);
        const h = try fmt.parseInt(u16, it.next().?, 10);

        return Box{
            .l = l,
            .w = w,
            .h = h,
        };
    }

    fn surfaceArea(box: Box) u16 {
        return 2 * box.l * box.w + 2 * box.l * box.h + 2 * box.w * box.h;
    }

    fn slackArea(box: Box) u16 {
        if (box.l > box.w and box.l > box.h) {
            return box.w * box.h;
        } else if (box.w > box.l and box.w > box.h) {
            return box.l * box.h;
        } else {
            return box.l * box.w;
        }
    }

    fn wrappingArea(box: Box) u16 {
        return box.surfaceArea() + box.slackArea();
    }
};
