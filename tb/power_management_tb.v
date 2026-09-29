`timescale 1ns/1ps

module power_management_tb;

reg clk;
reg reset;
reg active;

wire power_save;

// Instantiate Power Management
power_management uut (
    .clk(clk),
    .reset(reset),
    .active(active),
    .power_save(power_save)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("waveforms/power_management.vcd");
    $dumpvars(0, power_management_tb);

    clk = 0;
    reset = 1;
    active = 0;

    // Reset
    #10;
    reset = 0;

    // Accelerator becomes active
    active = 1;
    #10;

    // Accelerator becomes idle
    active = 0;
    #10;

    $finish;
end

endmodule