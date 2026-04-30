`timescale 1ns/1ps

module tinyfarm_button_pulse (
    input  logic clk,
    input  logic rst_n,
    input  logic btn_in,
    output logic pulse_out
);
    logic [2:0] sync_ff;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= 3'b000;
        end else begin
            sync_ff <= {sync_ff[1:0], btn_in};
        end
    end

    // Rising-edge pulse after synchronization.
    assign pulse_out = sync_ff[1] & ~sync_ff[2];
endmodule
