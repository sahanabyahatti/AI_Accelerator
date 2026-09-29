`timescale 1ns/1ps

module control_unit_tb;

reg clk;
reg reset;
reg start;

wire read_enable;
wire mac_enable;
wire output_enable;
wire done;

// Instantiate the Control Unit
control_unit uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .read_enable(read_enable),
    .mac_enable(mac_enable),
    .output_enable(output_enable),
    .done(done)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("waveforms/control_unit.vcd");
    $dumpvars(0, control_unit_tb);

    clk = 0;
    reset = 1;
    start = 0;

    // Reset the system
    #10;
    reset = 0;

    // Start the operation
    #10;
    start = 1;

    // Remove start signal
    #10;
    start = 0;

    // Wait for FSM to complete
    #40;

    $finish;
end

endmodule