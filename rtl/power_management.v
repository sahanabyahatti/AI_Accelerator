module power_management(
    input clk,
    input reset,
    input active,
    output reg power_save
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        power_save <= 1'b1;      // Power-saving mode after reset
    else if(active)
        power_save <= 1'b0;      // Accelerator is active
    else
        power_save <= 1'b1;      // Return to power-saving mode
end

endmodule