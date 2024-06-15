const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const hash = std.crypto.hash;
const mem = std.mem;

const stdout_file = io.getStdOut().writer();
var bw = io.bufferedWriter(stdout_file);
const stdout = bw.writer();

const input: []const u8 = "3113322113";

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var elements = std.StringHashMap(Element).init(allocator);
    var decayed = std.ArrayList([]const u8).init(allocator);
    var decay: Element = undefined;
    try decayed.append("Bi");
    try initAtoms(&elements);

    for (0..50) |i| {
        var new_decayed = std.ArrayList([]const u8).init(allocator);
        var length: u64 = 0;
        for (decayed.items) |element| {
            decay = elements.get(element).?;
            var it = mem.splitScalar(u8, decay.decays_into, '.');

            while (it.next()) |atom| {
                length += elements.get(atom).?.sequence.len;
                //length += 1;
                try new_decayed.append(atom);
            }
        }
        try stdout.print("{d} {d}\n", .{i, length});
        decayed = new_decayed;
    }

    try stdout.print("day 10:\n", .{});

    try bw.flush();
}

fn initAtoms(elements: *std.StringHashMap(Element)) !void {
    try elements.*.put("Ac", Element{.sequence = "3113", .decays_into = "Ra"});
    try elements.*.put("Ag", Element{.sequence = "132113212221", .decays_into = "Pd"});
    try elements.*.put("Al", Element{.sequence = "1113222112", .decays_into = "Mg"});
    try elements.*.put("Ar", Element{.sequence = "3112", .decays_into = "Cl"});
    try elements.*.put("As", Element{.sequence = "11131221131211322113322112", .decays_into = "Ge.Na"});
    try elements.*.put("At", Element{.sequence = "1322113", .decays_into = "Po"});
    try elements.*.put("Au", Element{.sequence = "132112211213322113", .decays_into = "Pt"});
    try elements.*.put("B", Element{.sequence = "1321132122211322212221121123222112", .decays_into = "Be"});
    try elements.*.put("Ba", Element{.sequence = "311311", .decays_into = "Cs"});
    try elements.*.put("Be", Element{.sequence = "111312211312113221133211322112211213322112", .decays_into = "Ge.Ca.Li"});
    try elements.*.put("Bi", Element{.sequence = "3113322113", .decays_into = "Pm.Pb"});
    try elements.*.put("Br", Element{.sequence = "3113112211322112", .decays_into = "Se"});
    try elements.*.put("C", Element{.sequence = "3113112211322112211213322112", .decays_into = "B"});
    try elements.*.put("Ca", Element{.sequence = "12", .decays_into = "K"});
    try elements.*.put("Cd", Element{.sequence = "3113112211", .decays_into = "Ag"});
    try elements.*.put("Ce", Element{.sequence = "1321133112", .decays_into = "La.H.Ca.Co"});
    try elements.*.put("Cl", Element{.sequence = "132112", .decays_into = "S"});
    try elements.*.put("Co", Element{.sequence = "32112", .decays_into = "Fe"});
    try elements.*.put("Cr", Element{.sequence = "31132", .decays_into = "V"});
    try elements.*.put("Cs", Element{.sequence = "13211321", .decays_into = "Xe"});
    try elements.*.put("Cu", Element{.sequence = "131112", .decays_into = "Ni"});
    try elements.*.put("Dy", Element{.sequence = "111312211312", .decays_into = "Tb"});
    try elements.*.put("Er", Element{.sequence = "311311222", .decays_into = "Ho.Pm"});
    try elements.*.put("Eu", Element{.sequence = "1113222", .decays_into = "Sm"});
    try elements.*.put("F", Element{.sequence = "31121123222112", .decays_into = "O"});
    try elements.*.put("Fe", Element{.sequence = "13122112", .decays_into = "Mn"});
    try elements.*.put("Fr", Element{.sequence = "1113122113", .decays_into = "Rn"});
    try elements.*.put("Ga", Element{.sequence = "13221133122211332", .decays_into = "Eu.Ca.Ac.H.Ca.Zn"});
    try elements.*.put("Gd", Element{.sequence = "13221133112", .decays_into = "Eu.Ca.Co"});
    try elements.*.put("Ge", Element{.sequence = "31131122211311122113222", .decays_into = "Ho.Ga"});
    try elements.*.put("H", Element{.sequence = "22", .decays_into = "H"});
    try elements.*.put("He", Element{.sequence = "13112221133211322112211213322112", .decays_into = "Hf.Pa.H.Ca.Li"});
    try elements.*.put("Hf", Element{.sequence = "11132", .decays_into = "Lu"});
    try elements.*.put("Hg", Element{.sequence = "31121123222113", .decays_into = "Au"});
    try elements.*.put("Ho", Element{.sequence = "1321132", .decays_into = "Dy"});
    try elements.*.put("I", Element{.sequence = "311311222113111221", .decays_into = "Ho.Te"});
    try elements.*.put("Ir", Element{.sequence = "3113112211322112211213322113", .decays_into = "Os"});
    try elements.*.put("In", Element{.sequence = "11131221", .decays_into = "Cd"});
    try elements.*.put("K", Element{.sequence = "1112", .decays_into = "Ar"});
    try elements.*.put("Kr", Element{.sequence = "11131221222112", .decays_into = "Br"});
    try elements.*.put("La", Element{.sequence = "11131", .decays_into = "Ba"});
    try elements.*.put("Li", Element{.sequence = "312211322212221121123222112", .decays_into = "He"});
    try elements.*.put("Lu", Element{.sequence = "311312", .decays_into = "Yb"});
    try elements.*.put("Mg", Element{.sequence = "3113322112", .decays_into = "Pm.Na"});
    try elements.*.put("Mn", Element{.sequence = "111311222112", .decays_into = "Cr.Si"});
    try elements.*.put("Mo", Element{.sequence = "13211322211312113211", .decays_into = "Nb"});
    try elements.*.put("N", Element{.sequence = "111312212221121123222112", .decays_into = "C"});
    try elements.*.put("Na", Element{.sequence = "123222112", .decays_into = "Ne"});
    try elements.*.put("Nb", Element{.sequence = "1113122113322113111221131221", .decays_into = "Er.Zr"});
    try elements.*.put("Nd", Element{.sequence = "111312", .decays_into = "Pr"});
    try elements.*.put("Ne", Element{.sequence = "111213322112", .decays_into = "F"});
    try elements.*.put("Ni", Element{.sequence = "11133112", .decays_into = "Zn.Co"});
    try elements.*.put("O", Element{.sequence = "132112211213322112", .decays_into = "N"});
    try elements.*.put("Os", Element{.sequence = "1321132122211322212221121123222113", .decays_into = "Re"});
    try elements.*.put("P", Element{.sequence = "311311222112", .decays_into = "Ho.Si"});
    try elements.*.put("Pa", Element{.sequence = "13", .decays_into = "Th"});
    try elements.*.put("Pb", Element{.sequence = "123222113", .decays_into = "Tl"});
    try elements.*.put("Pd", Element{.sequence = "111312211312113211", .decays_into = "Rh"});
    try elements.*.put("Pm", Element{.sequence = "132", .decays_into = "Nd"});
    try elements.*.put("Po", Element{.sequence = "1113222113", .decays_into = "Bi"});
    try elements.*.put("Pr", Element{.sequence = "31131112", .decays_into = "Ce"});
    try elements.*.put("Pt", Element{.sequence = "111312212221121123222113", .decays_into = "Ir"});
    try elements.*.put("Ra", Element{.sequence = "132113", .decays_into = "Fr"});
    try elements.*.put("Rb", Element{.sequence = "1321122112", .decays_into = "Kr"});
    try elements.*.put("Re", Element{.sequence = "111312211312113221133211322112211213322113", .decays_into = "Ge.Ca.W"});
    try elements.*.put("Rh", Element{.sequence = "311311222113111221131221", .decays_into = "Ho.Ru"});
    try elements.*.put("Rn", Element{.sequence = "311311222113", .decays_into = "Ho.At"});
    try elements.*.put("Ru", Element{.sequence = "132211331222113112211", .decays_into = "Eu.Ca.Tc"});
    try elements.*.put("S", Element{.sequence = "1113122112", .decays_into = "P"});
    try elements.*.put("Sb", Element{.sequence = "3112221", .decays_into = "Pm.Sn"});
    try elements.*.put("Sc", Element{.sequence = "3113112221133112", .decays_into = "Ho.Pa.H.Ca.Co"});
    try elements.*.put("Se", Element{.sequence = "13211321222113222112", .decays_into = "As"});
    try elements.*.put("Si", Element{.sequence = "1322112", .decays_into = "Al"});
    try elements.*.put("Sm", Element{.sequence = "311332", .decays_into = "Pm.Ca.Zn"});
    try elements.*.put("Sn", Element{.sequence = "13211", .decays_into = "In"});
    try elements.*.put("Sr", Element{.sequence = "3112112", .decays_into = "Rb"});
    try elements.*.put("Ta", Element{.sequence = "13112221133211322112211213322113", .decays_into = "Hf.Pa.H.Ca.W"});
    try elements.*.put("Tb", Element{.sequence = "3113112221131112", .decays_into = "Ho.Gd"});
    try elements.*.put("Tc", Element{.sequence = "311322113212221", .decays_into = "Mo"});
    try elements.*.put("Te", Element{.sequence = "1322113312211", .decays_into = "Eu.Ca.Sb"});
    try elements.*.put("Th", Element{.sequence = "1113", .decays_into = "Ac"});
    try elements.*.put("Ti", Element{.sequence = "11131221131112", .decays_into = "Sc"});
    try elements.*.put("Tl", Element{.sequence = "111213322113", .decays_into = "Hg"});
    try elements.*.put("Tm", Element{.sequence = "11131221133112", .decays_into = "Er.Ca.Co"});
    try elements.*.put("U", Element{.sequence = "3", .decays_into = "Pa"});
    try elements.*.put("V", Element{.sequence = "13211312", .decays_into = "Ti"});
    try elements.*.put("W", Element{.sequence = "312211322212221121123222113", .decays_into = "Ta"});
    try elements.*.put("Xe", Element{.sequence = "11131221131211", .decays_into = "I"});
    try elements.*.put("Y", Element{.sequence = "1112133", .decays_into = "Sr.U"});
    try elements.*.put("Yb", Element{.sequence = "1321131112", .decays_into = "Tm"});
    try elements.*.put("Zn", Element{.sequence = "312", .decays_into = "Cu"});
    try elements.*.put("Zr", Element{.sequence = "12322211331222113112211", .decays_into = "Y.H.Ca.Tc"});
}

const Element = struct {
    sequence: []const u8,
    decays_into: []const u8,
};
