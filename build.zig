const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

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

    // engine module
    const mod_engine = b.addModule("engine", .{
        .root_source_file = b.path("src/engine/+root.zig"),
        .target = target,
    });
    const mod_engine_test = b.addModule("engine_test", .{
        .root_source_file = b.path("src/engine/+test.zig"),
        .target = target,
    });

    // gui module
    const mod_gui = b.addModule("gui", .{
        .root_source_file = b.path("src/gui/+root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "engine", .module = mod_engine },
            .{ .name = "raylib", .module = raylib },
            .{ .name = "raygui", .module = raygui },
        },
    });
    const mod_gui_test = b.addModule("gui_test", .{
        .root_source_file = b.path("src/gui/+test.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "engine", .module = mod_engine },
            .{ .name = "raylib", .module = raylib },
            .{ .name = "raygui", .module = raygui },
        },
    });

    // main executable
    const exe = b.addExecutable(.{
        .name = "sharpchess",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "engine", .module = mod_engine },
                .{ .name = "raylib", .module = raylib },
                .{ .name = "raygui", .module = raygui },
                .{ .name = "gui", .module = mod_gui },
            },
        }),
    });

    exe.linkLibrary(raylib_artifact);
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    // allow passing cmd line arguments like this `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // declare tests
    // engine module test
    const test_engine = b.addTest(.{
        .root_module = mod_engine_test,
    });
    const run_test_engine = b.addRunArtifact(test_engine);

    // gui module test
    const test_gui = b.addTest(.{
        .root_module = mod_gui_test,
    });
    const run_test_gui = b.addRunArtifact(test_gui);

    // main test
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    // run test
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
    test_step.dependOn(&run_test_engine.step);
    test_step.dependOn(&run_test_gui.step);
}
