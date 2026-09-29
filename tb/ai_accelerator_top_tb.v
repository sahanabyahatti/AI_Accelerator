`timescale 1ns/1ps

module ai_accelerator_top_tb;

reg clk;
reg reset;
reg start;

reg write_enable;
reg [1:0] address;
reg [7:0] input_data;

reg weight_write_enable;
reg [1:0] weight_write_address;
reg [7:0] weight_in;

wire [15:0] final_output;
wire done;
wire power_save;

reg [7:0] test_input [0:3];
reg [7:0] test_weight [0:3];

integer expected_result;
integer i;
integer test_num;

ai_accelerator_top uut (
    .clk(clk),
    .reset(reset),
    .start(start),

    .input_data(input_data),
    .write_enable(write_enable),
    .address(address),

    .weight_write_enable(weight_write_enable),
    .weight_write_address(weight_write_address),
    .weight_in(weight_in),

    .final_output(final_output),
    .done(done),
    .power_save(power_save)
);

always #5 clk = ~clk;

initial
begin

    $dumpfile("waveforms/ai_accelerator_top.vcd");
    $dumpvars(0, ai_accelerator_top_tb);

    clk = 0;
    reset = 1;
    start = 0;

    write_enable = 0;
    address = 0;
    input_data = 0;

    weight_write_enable = 0;
    weight_write_address = 0;
    weight_in = 0;

    expected_result = 0;

    //------------------------------------------------
    // RUN 10 TESTS
    //------------------------------------------------

    for (test_num = 1; test_num <= 10; test_num = test_num + 1)
    begin

        $display("");
        $display("=================================");
        $display("RANDOM TEST %0d", test_num);
        $display("=================================");

        //------------------------------------------------
        // RESET
        //------------------------------------------------

        reset = 1;
        start = 0;
        write_enable = 0;
        weight_write_enable = 0;

        #10;

        reset = 0;

        expected_result = 0;

        //------------------------------------------------
        // GENERATE RANDOM DATA
        //------------------------------------------------

        for (i = 0; i < 4; i = i + 1)
        begin

            test_input[i] = $urandom_range(1, 20);
            test_weight[i] = $urandom_range(1, 10);

            expected_result =
                expected_result +
                (test_input[i] * test_weight[i]);

            $display(
                "Input[%0d] = %0d, Weight[%0d] = %0d",
                i,
                test_input[i],
                i,
                test_weight[i]
            );

        end

        //------------------------------------------------
        // LOAD INPUTS
        //------------------------------------------------

        write_enable = 1;

        for (i = 0; i < 4; i = i + 1)
        begin

            address = i;
            input_data = test_input[i];

            #10;

        end

        write_enable = 0;

        //------------------------------------------------
        // LOAD WEIGHTS
        //------------------------------------------------

        weight_write_enable = 1;

        for (i = 0; i < 4; i = i + 1)
        begin

            weight_write_address = i;
            weight_in = test_weight[i];

            #10;

        end

        weight_write_enable = 0;

        //------------------------------------------------
        // START
        //------------------------------------------------

        #10;

        start = 1;

        #10;

        start = 0;

        //------------------------------------------------
        // WAIT
        //------------------------------------------------

        #100;

        //------------------------------------------------
        // CHECK RESULT
        //------------------------------------------------

        $display("---------------------------------");
        $display("Expected result = %0d", expected_result);
        $display("Actual result   = %0d", final_output);

        if (final_output == expected_result)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $display("---------------------------------");

    end

    //------------------------------------------------
    // FINISH
    //------------------------------------------------

    $display("");
    $display("=================================");
    $display("10 RANDOM TESTS COMPLETED");
    $display("=================================");

    $finish;

end

endmodule