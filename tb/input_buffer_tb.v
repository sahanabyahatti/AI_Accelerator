`timescale 1ns/1ps

module input_buffer_tb;

reg clk;
reg reset;
reg write_enable;
reg [7:0] data_in;

wire [7:0] data_out;

// Instantiate the Input Buffer
input_buffer uut (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .data_in(data_in),
    .data_out(data_out)
);

// Clock generation (10 ns period)
always #5 clk = ~clk;

initial begin
    // Create VCD file for GTKWave
    $dumpfile("waveforms/input_buffer.vcd");
    $dumpvars(0, input_buffer_tb);

    // Initialize signals
    clk = 0;
    reset = 1;
    write_enable = 0;
    data_in = 8'd0;

    #10;
    reset = 0;

    // Write first value
    write_enable = 1;
    data_in = 8'd25;
    #10;

    // Write second value
    data_in = 8'd100;
    #10;

    // Disable writing
    write_enable = 0;
    data_in = 8'd50;
    #10;

    $finish;
end

endmodule