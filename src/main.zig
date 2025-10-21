const std = @import("std");

const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("string.h");
});

pub fn main() !void {
    c.printf("Hello_world");
}
