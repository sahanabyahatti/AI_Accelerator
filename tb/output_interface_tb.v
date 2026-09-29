`timescale 1ns/1ps

module output_interface_tb;

reg clk;
reg reset;
reg valid;
reg [15:0] data_in;

wire [15:0] final_output;

// Instantiate Output Interface
output_interface uut (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .data_in(data_in),
    .final_output(final_output)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("waveforms/output_interface.vcd");
    $dumpvars(0, output_interface_tb);

    clk = 0;
    reset = 1;
    valid = 0;
    data_in = 16'd0;

    // Reset
    #10;
    reset = 0;

    // Send first value
    valid = 1;
    data_in = 16'd29;
    #10;

    // Send second value
    data_in = 16'd50;
    #10;

    // Disable output
    valid = 0;
    data_in = 16'd100;
    #10;

    $finish;
end

endmodule