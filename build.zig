// How does a build.zig file work

// const std = @import("std"); --> Zig standard library import
//      - it allows us to use std.Build that contains API to define target, executables, libraries, options.

// pub fn build(b: *std.Build) void { --> entry point function of build system.
//      - when we execute zig build from terminal Zig search and call this function.
//      - b is a parameter that represents a pointer to the (compilation process) std.Build

//  const target = b.standardTargetOptions(.{});  --> allows us to specify the platform for which we want to compile (e.g, x86, ARM, etc)
//                                                    standard is the current system?
//  const optimize = b.standardOptimizeOption(.{}); --> defines the optimization level (configurable from terminal)

//  const exe = b.addExecutable --> defines the main executable
//      .name = ?
//      .root_source_file = zig main from which the program starts.
//      .target and .optimize have been defined earlier.
//          b.path("src/main.zig") --> path from the build's root

//   exe.addIncludePath(b.path("deps/CMSIS-NN/Include"));
//   exe.addIncludePath(b.path("deps/CMSIS-DSP/Include/"));
//   tell the compiler where to search for header.h files.

//   exe.addCSourceFile --> add a source C file to be compile together with Zig code
//          .file --> percpath of the file .c
//          .flag --> options to be passed to the compiler

//   exe.linkLibC(); --> tells the system Build that this executable must be linked to libc (C standard library) since the C file uses it.
//   b.installArtifact(exe); --> installs the executable and copies it in .zig-out/bin/ as default

//   b.addRunArtifact(exe) --> create an action to execute the executable after it has been compiled
//   b.step() --> // I don't understand it

// So the Idea is that build.zig builds a zig program. In this case the program will contain C code (CMSIS-NN):
//          - it specifies where the header are located
//          - then compiles
//          - then run
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

const std = @import("std");

// Importa la configurazione locale
const config = @import("local_config.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .thumb,
            .os_tag = .freestanding,
            .abi = .eabihf,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        },
    });

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-cmsis-nn-demo",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // === CMSIS includes ===
    exe.addIncludePath(b.path("deps/CMSIS-NN/Include"));
    exe.addIncludePath(b.path("deps/CMSIS-DSP/Include"));

    // === CMSIS C sources ===

    const cmsis_flags = [_][]const u8{
        "-std=c99",
        "-DARM_MATH_DSP",
        "-DARM_MATH_CM4",
        "-Wall",
    };

    exe.addCSourceFile(.{
        .file = b.path("deps/CMSIS-NN/Source/ConvolutionFunctions/arm_convolve_s8.c"),
        .flags = &cmsis_flags,
    });

    exe.addCSourceFile(.{
        .file = b.path("deps/CMSIS-NN/Source/NNSupportFunctions/arm_s8_to_s16_unordered_with_offset.c"),
        .flags = &cmsis_flags,
    });

    exe.addCSourceFile(.{
        .file = b.path("deps/CMSIS-NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_row_offset_s8_s16.c"),
        .flags = &cmsis_flags,
    });

    exe.addCSourceFile(.{
        .file = b.path("deps/CMSIS-NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_s8_s16.c"),
        .flags = &cmsis_flags,
    });

    // === Toolchain include/library paths ===
    exe.addIncludePath(.{ .cwd_relative = config.arm_gnu_include });
    exe.addLibraryPath(.{ .cwd_relative = config.arm_gnu_lib });
    exe.addLibraryPath(.{ .cwd_relative = config.arm_gnu_lib_gcc });

    // === Link standard libraries ===
    //exe.linkLibC();
    exe.linkSystemLibrary("m");
    exe.linkSystemLibrary("gcc");

    // === Force static linking (bare-metal target) ===
    exe.linkage = .static;

    b.installArtifact(exe);
}
