`timescale 1ns/1ps

module tinyfarm_vga_timing (
    input  logic clk,
    input  logic rst_n,
    output logic [9:0] hcount,
    output logic [9:0] vcount,
    output logic hsync,
    output logic vsync,
    output logic visible
);
    // 640x480 @ 60 Hz timing.
    // Intended for a nominal ~25 MHz pixel clock.
    localparam logic [9:0] H_VISIBLE = 10'd640;
    localparam logic [9:0] H_FRONT   = 10'd16;
    localparam logic [9:0] H_SYNC    = 10'd96;
    localparam logic [9:0] H_BACK    = 10'd48;
    localparam logic [9:0] H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    localparam logic [9:0] V_VISIBLE = 10'd480;
    localparam logic [9:0] V_FRONT   = 10'd10;
    localparam logic [9:0] V_SYNC    = 10'd2;
    localparam logic [9:0] V_BACK    = 10'd33;
    localparam logic [9:0] V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hcount <= 10'd0;
            vcount <= 10'd0;
        end else begin
            if (hcount == H_TOTAL - 10'd1) begin
                hcount <= 10'd0;
                if (vcount == V_TOTAL - 10'd1) begin
                    vcount <= 10'd0;
                end else begin
                    vcount <= vcount + 10'd1;
                end
            end else begin
                hcount <= hcount + 10'd1;
            end
        end
    end

    assign visible = (hcount < H_VISIBLE) && (vcount < V_VISIBLE);

    assign hsync = ~((hcount >= H_VISIBLE + H_FRONT) &&
                     (hcount <  H_VISIBLE + H_FRONT + H_SYNC));

    assign vsync = ~((vcount >= V_VISIBLE + V_FRONT) &&
                     (vcount <  V_VISIBLE + V_FRONT + V_SYNC));
endmodule
