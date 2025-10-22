const std = @import("std");

const c = @cImport({
    @cInclude("arm_nnfunctions.h");
    @cInclude("stdio.h");
    //@cInclude("string.h");
});

// the following main initializes CMSIS structure and calls arm_convolve_s8()
pub fn main() !void {

    // Look at  deps\CMSIS-NN\Include\arm_nnfunctions.h  to understand how to call CMSIS-NN convolution arm_convolve_s8.
    // check all the files included by arm_nnfunctions.h: in particular arm_nn_types.h and arm_nn_math_types.h.
    //  - They define CMSIS-NN structs used as input parameters in arm_convolve_s8:
    //            - cmsis_nn_context,
    //            - cmsis_nn_conv_params
    //            - cmsis_nn_per_channel_quant_params
    //            - cmsis_nn_dims

    // necessary to allocate temporary buffer used in the convolution
    var ctx: c.cmsis_nn_context = .{
        .buf = null, //pointer to the buffer
        .size = 0,
    };

    var conv_params: c.cmsis_nn_conv_params = .{
        .input_offset = 0,
        .output_offset = 0,
        .stride = .{ .w = 1, .h = 1 },
        .padding = .{ .w = 0, .h = 0 },
        .dilation = .{ .w = 1, .h = 1 },
        .activation = .{ .min = -128, .max = 127 },
    };

    var quant_params: c.cmsis_nn_per_channel_quant_params = .{
        .multiplier = null,
        .shift = null,
    };

    // n = batch size
    // h = rows
    // W = columns
    // c = channles
    var input_dims: c.cmsis_nn_dims = .{ .n = 1, .w = 3, .h = 3, .c = 1 };
    var filter_dims: c.cmsis_nn_dims = .{ .w = 2, .h = 2, .c = 1 };
    var bias_dims: c.cmsis_nn_dims = .{ .w = 1, .h = 1, .c = 1 };
    var output_dims: c.cmsis_nn_dims = .{ .w = 2, .h = 2, .c = 1 };

    // test Data
    var input_data: [9]i8 = [_]i8{ 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    var filter_data: [4]i8 = [_]i8{ 1, 0, 0, 1 };
    var bias_data: [1]i32 = [_]i32{0};
    var output_data: [4]i8 = undefined;

    // CMSIS call
    const result = c.arm_convolve_s8(
        &ctx,
        &conv_params,
        &quant_params,
        &input_dims,
        &input_data,
        &filter_dims,
        &filter_data,
        &bias_dims,
        &bias_data,
        null,
        &output_dims,
        &output_data,
    );

    // print result
    _ = c.printf("Result code: %d\n", result);
    _ = c.printf("Output: %d %d %d %d\n", output_data[0], output_data[1], output_data[2], output_data[3]);
}
