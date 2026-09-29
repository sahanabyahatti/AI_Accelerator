module mac_unit (
    input clk,
    input reset,
    input enable,
    input [7:0] input_data,
    input [7:0] weight,
    output reg [15:0] result,
    output reg overflow
);

reg [15:0] product;
reg [16:0] sum;

always @(*) begin
    product = input_data * weight;
    sum = {1'b0, result} + {1'b0, product};
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        result <= 16'd0;
        overflow <= 1'b0;
    end
    else if (enable) begin
        result <= sum[15:0];

        if (sum[16])
            overflow <= 1'b1;
    end
end

endmodule