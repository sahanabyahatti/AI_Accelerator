module ai_accelerator_top(
    input clk,
    input reset,
    input start,

    // Input data loading
    input [7:0] input_data,
    input write_enable,
    input [1:0] address,

    // Weight loading
    input weight_write_enable,
    input [1:0] weight_write_address,
    input [7:0] weight_in,

    // Outputs
    output [15:0] final_output,
    output done,
    output power_save
);

wire [7:0] buffered_data;
wire [7:0] weight;
wire [15:0] mac_result;
wire [15:0] buffer_output;

wire read_enable;
wire mac_enable;
wire output_enable;

wire [1:0] processing_address;


//------------------------------------------------
// CONTROL UNIT
//------------------------------------------------

control_unit u_control_unit(
    .clk(clk),
    .reset(reset),
    .start(start),
    .read_enable(read_enable),
    .mac_enable(mac_enable),
    .output_enable(output_enable),
    .done(done),
    .processing_address(processing_address)
);

//------------------------------------------------
// INPUT BUFFER
//------------------------------------------------

input_buffer u_input_buffer(
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .write_address(address),
    .read_address(processing_address),
    .data_in(input_data),
    .data_out(buffered_data)
);


//------------------------------------------------
// WEIGHT MEMORY
//------------------------------------------------

weight_memory u_weight_memory(
    .clk(clk),
    .reset(reset),
    .write_enable(weight_write_enable),
    .write_address(weight_write_address),
    .weight_in(weight_in),
    .address(processing_address),
    .weight(weight)
);


//------------------------------------------------
// MAC UNIT
//------------------------------------------------

mac_unit u_mac_unit(
    .clk(clk),
    .reset(reset),
    .enable(mac_enable),
    .input_data(buffered_data),
    .weight(weight),
    .result(mac_result)
);


//------------------------------------------------
// OUTPUT BUFFER
//------------------------------------------------

output_buffer u_output_buffer(
    .clk(clk),
    .reset(reset),
    .write_enable(output_enable),
    .data_in(mac_result),
    .data_out(buffer_output)
);


//------------------------------------------------
// OUTPUT INTERFACE
//------------------------------------------------

output_interface u_output_interface(
    .clk(clk),
    .reset(reset),
    .valid(output_enable),
    .data_in(mac_result),
    .final_output(final_output)
);


//------------------------------------------------
// POWER MANAGEMENT
//------------------------------------------------

power_management u_power_management(
    .clk(clk),
    .reset(reset),
    .active(~done),
    .power_save(power_save)
);

endmodule