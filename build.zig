const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const qjsMod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });

    const flags: []const []const u8 = if (target.query.abi == .msvc)
        &.{
            "-DZIG_BUILD",
            "-DWIN32_LEAN_AND_MEAN",
        }
    else
        &.{
            "-std=gnu11",
            "-DZIG_BUILD",
            "-D_GNU_SOURCE",
        };

    const sources: []const []const u8 = if (target.query.abi == .msvc) &.{
        "cutils.c",
        "dtoa.c",
        "libregexp.c",
        "libunicode.c",
        "quickjs.c",
    } else &.{
        "cutils.c",
        "dtoa.c",
        "libregexp.c",
        "libunicode.c",
        "quickjs.c",
        "quickjs-libc.c",
    };

    qjsMod.addCSourceFiles(.{
        .files = sources,
        .flags = flags,
    });

    const dynlib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "quickjs",
        .root_module = qjsMod,
    });
    dynlib.linkLibC();
    b.installArtifact(dynlib);

    const staticlib = b.addLibrary(.{
        .linkage = .static,
        .name = "quickjs_static",
        .root_module = qjsMod,
    });
    staticlib.linkLibC();
    b.installArtifact(staticlib);
}
