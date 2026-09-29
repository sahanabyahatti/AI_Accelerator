`timescale 1ns/1ps

module output_buffer_tb;

reg clk;
reg reset;
reg write_enable;
reg [15:0] data_in;

wire [15:0] data_out;

// Instantiate Output Buffer
output_buffer uut (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .data_in(data_in),
    .data_out(data_out)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("waveforms/output_buffer.vcd");
    $dumpvars(0, output_buffer_tb);

    clk = 0;
    reset = 1;
    write_enable = 0;
    data_in = 16'd0;

    // Reset
    #10;
    reset = 0;

    // Write first value
    write_enable = 1;
    data_in = 16'd29;
    #10;

    // Write second value
    data_in = 16'd50;
    #10;

    // Disable writing
    write_enable = 0;
    data_in = 16'd100;
    #10;

    $finish;
end

endmodule