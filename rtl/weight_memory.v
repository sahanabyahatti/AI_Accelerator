module weight_memory (
    input clk,
    input reset,

    // Write interface
    input write_enable,
    input [1:0] write_address,
    input [7:0] weight_in,

    // Read interface
    input [1:0] address,
    output reg [7:0] weight
);

reg [7:0] memory [0:3];

integer i;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        for (i = 0; i < 4; i = i + 1)
            memory[i] <= 8'd0;
    end
    else if (write_enable)
    begin
        memory[write_address] <= weight_in;
    end
end

// Synchronous read
always @(posedge clk)
begin
    weight <= memory[address];
end

endmodule