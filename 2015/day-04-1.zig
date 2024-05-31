const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const hash = std.crypto.hash;
const mem = std.mem;

const input: []const u8 = "bgvyzdsv";
const limit: u20 = 1000000;
var candidate: u20 = 1;
const buffSize: usize = 9;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var out: [hash.Md5.digest_length]u8 = undefined;

    var decimalBuffer: [buffSize]u8 = undefined;
    var inputBuffer: [8 + buffSize]u8 = undefined;
    mem.copyForwards(u8, inputBuffer[0..], input);
    var decimalBytes: DecimalBytes = undefined;

    while (candidate < limit and (out[0] != 0 or out[1] != 0 or out[2] > 15)) {
        decimalBytes = DecimalBytes.init(candidate, &decimalBuffer);
        mem.copyForwards(u8, inputBuffer[input.len..], decimalBytes.bytes.*[0..decimalBytes.len]);
        hash.Md5.hash(inputBuffer[0 .. decimalBytes.len + input.len], &out, .{});
        candidate += 1;
    }

    try stdout.print("day 3: {s} {s} {d}\n", .{ fmt.fmtSliceHexLower(&out), input, candidate - 1 });

    try bw.flush();
}

const DecimalBytes = struct {
    bytes: *const *[buffSize]u8,
    len: usize,

    fn init(num: u20, decimalBuffer: *[buffSize]u8) DecimalBytes {
        var remainder: u20 = num;
        var idx: u3 = 0;
        var tempIdx: u3 = 0;
        var tempBuffer: [buffSize]u8 = undefined;

        while (remainder > 0) : (tempIdx += 1) {
            tempBuffer[tempIdx] = @truncate(remainder % 10 + 48); // to ascii value
            remainder = remainder / 10;
        }

        while (tempIdx > 0) : (idx += 1) {
            tempIdx -= 1;
            decimalBuffer[idx] = tempBuffer[tempIdx];
        }

        return DecimalBytes{ .bytes = &decimalBuffer, .len = idx };
    }
};
