`timescale 1ns/1ps

module weight_memory_tb;

reg clk;
reg [1:0] address;
wire [7:0] weight;

// Instantiate Weight Memory
weight_memory uut (
    .clk(clk),
    .address(address),
    .weight(weight)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    // Create VCD file
    $dumpfile("waveforms/weight_memory.vcd");
    $dumpvars(0, weight_memory_tb);

    clk = 0;

    // Read weight at address 0
    address = 2'b00;
    #10;

    // Read weight at address 1
    address = 2'b01;
    #10;

    // Read weight at address 2
    address = 2'b10;
    #10;

    // Read weight at address 3
    address = 2'b11;
    #10;

    $finish;
end

endmodule