module output_interface(
    input clk,
    input reset,
    input valid,
    input [15:0] data_in,
    output reg [15:0] final_output
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        final_output <= 16'd0;
    else if(valid)
        final_output <= data_in;
end

endmodule