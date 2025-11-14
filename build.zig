const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // engine module
    const mod_engine = b.addModule("engine", .{
        .root_source_file = b.path("src/engine/engine.zig"),
        .target = target,
    });
    const mod_engine_test = b.addModule("engine_test", .{
        .root_source_file = b.path("src/engine/test.zig"),
        .target = target,
    });

    // raylib module
    const rlz = @import("raylib_zig");
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
        .opengl_version = rlz.OpenglVersion.gl_2_1, // Use OpenGL 2.1 (requires importing raylib-zig's build script)
    });
    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    // main executable
    const exe = b.addExecutable(.{
        .name = "engine",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "engine", .module = mod_engine },
                .{ .name = "raylib", .module = raylib },
                .{ .name = "raygui", .module = raygui },
            },
        }),
    });

    exe.linkLibrary(raylib_artifact);
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const test_engine = b.addTest(.{
        .root_module = mod_engine_test,
    });
    const run_test_engine = b.addRunArtifact(test_engine);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
    test_step.dependOn(&run_test_engine.step);
}
