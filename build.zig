const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mod = b.addModule("yazml", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });
    const lib = b.addLibrary(.{
        .name = "yazml",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "yazml", .module = mod },
            },
        }),
    });

    b.installArtifact(lib);
}
