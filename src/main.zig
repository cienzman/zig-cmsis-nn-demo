const std = @import("std");

// header file import
const cmsis_nn = @cImport({
    @cInclude("arm_nnfunctions.h");
});

pub fn main() !void { //CHATGPT GENERATED FOR QUICK TEST
    const stdout = std.io.getStdOut().writer();

    // Stampa per confermare che compila
    try stdout.print("CMSIS-NN Zig Demo\n", .{});

    // Creiamo un placeholder per richiamare la funzione (test di compilazione)
    // NB: non stiamo ancora passando dati reali, vogliamo solo verificare l'import
    const dummy_ctx: cmsis_nn.cmsis_nn_context = undefined;
    const dummy_conv_params: cmsis_nn.cmsis_nn_conv_params = undefined;
    const dummy_quant_params: cmsis_nn.cmsis_nn_per_channel_quant_params = undefined;
    const dummy_input_dims: cmsis_nn.cmsis_nn_dims = undefined;
    const dummy_filter_dims: cmsis_nn.cmsis_nn_dims = undefined;
    const dummy_bias_dims: cmsis_nn.cmsis_nn_dims = undefined;
    const dummy_upscale_dims: cmsis_nn.cmsis_nn_dims = undefined;
    const dummy_output_dims: cmsis_nn.cmsis_nn_dims = undefined;

    const result = cmsis_nn.arm_convolve_s8(
        &dummy_ctx,
        &dummy_conv_params,
        &dummy_quant_params,
        &dummy_input_dims,
        @ptrCast([*c]const i8),
        &dummy_filter_dims,
        @ptrCast([*c]const i8),
        &dummy_bias_dims,
        @ptrCast([*c]const i32),
        &dummy_upscale_dims,
        &dummy_output_dims,
        @ptrCast([*c]i8),
    );

    try stdout.print("Result code: {d}\n", .{result});
}
