# ZANT – CMSIS-NN Integration Demo

## General Overview

This repository demonstrates how to integrate **CMSIS-NN** (Arm’s optimized neural network library for Cortex-M microcontrollers) within the **ZANT** framework, which is written in **Zig**.

The goal of this demo is to prove that:
- Zig can successfully compile and link C sources from CMSIS-NN.
- We can call CMSIS functions such as `arm_convolve_s8()` directly from Zig.
- Data structures (layout, quantization parameters, buffers) can be correctly passed between Zig and C.

---

## Objective

**ZANT Integration with CMSIS-NN**  
This phase focuses on managing CMSIS dependencies and building a minimal working integration.

### Goals
- Import and configure CMSIS-NN within a Zig build system.  
- Understand required headers and libraries (e.g. `arm_nnfunctions.h`, `arm_math.h`).  
- Configure Zig’s `build.zig` to include and compile CMSIS-NN sources.  
- Verify that Zig can call CMSIS convolution functions at runtime.

---

## Build Configuration

The Zig build script (`build.zig`) sets up:
- Cross-compilation for **ARM Cortex-M4** (thumb-freestanding).
- Inclusion of CMSIS-NN and CMSIS-DSP headers.
- Compilation of selected CMSIS C source files.
- Linking with required math and GCC libraries for bare-metal builds.

---

## Zig Main Program

`src/main.zig` demonstrates a minimal convolution example using **CMSIS-NN**.

- Structures imported from C:
  - `cmsis_nn_context`
  - `cmsis_nn_conv_params`
  - `cmsis_nn_per_channel_quant_params`
  - `cmsis_nn_dims`

- Static input/filter/bias tensors defined directly in Zig.  
- Invocation of `arm_convolve_s8()` through `@cImport`.  

---

## How to Build and Run

```bash
# 1. Clone and enter the project
git clone --recurse-submodules https://github.com/cienzman/zig-cmsis-nn-demo.git
cd zig-cmsis-nn-demo

# 2. Ensure CMSIS-NN and CMSIS-DSP sources are inside deps/

# 3. Build the demo
zig build

# 4. Run it
zig build run

```
---



