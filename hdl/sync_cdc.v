`timescale 1ns/100ps

module sync_cdc (
    input wire src_in,
    input wire dest_clk,

    output wire dest_out
);

    xpm_cdc_single #(
        .DEST_SYNC_FF (4),
        .SIM_ASSERT_CHK (0),
        .SRC_INPUT_REG (0)
    ) xpm_cdc_single_inst (
        .src_clk (0),
        .src_in (src_in),
        .dest_clk (dest_clk),
        .dest_out (dest_out)
    );

endmodule
