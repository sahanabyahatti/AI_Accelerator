`timescale 1ns/1ps

module mac_unit_tb;

reg clk;
reg reset;
reg enable;
reg [7:0] input_data;
reg [7:0] weight;

wire [15:0] result;

mac_unit uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .input_data(input_data),
    .weight(weight),
    .result(result)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    // Create waveform
    $dumpfile("waveforms/mac_unit.vcd");
    $dumpvars(0, mac_unit_tb);

    // Initial values
    clk = 0;
    reset = 1;
    enable = 0;
    input_data = 0;
    weight = 0;

    // Reset
    #10;
    reset = 0;

    // 5 × 4 = 20
    input_data = 8'd5;
    weight = 8'd4;
    enable = 1;
    #10;

    // 3 × 5 = 15 → total 35
    input_data = 8'd3;
    weight = 8'd5;
    #10;

    // 2 × 6 = 12 → total 47
    input_data = 8'd2;
    weight = 8'd6;
    #10;

    // 4 × 2 = 8 → total 55
    input_data = 8'd4;
    weight = 8'd2;
    #10;

    enable = 0;

    #10;

    $finish;

end

endmodule