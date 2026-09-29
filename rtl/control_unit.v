module control_unit (
    input clk,
    input reset,
    input start,

    output reg read_enable,
    output reg mac_enable,
    output reg output_enable,
    output reg done,

    output reg [1:0] processing_address
);

reg [2:0] state;

parameter IDLE    = 3'b000,
          READ    = 3'b001,
          COMPUTE = 3'b010,
          STORE   = 3'b011,
          OUTPUT  = 3'b100;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        state <= IDLE;
        processing_address <= 2'b00;
    end
    else
    begin
        case (state)

            IDLE:
            begin
                processing_address <= 2'b00;

                if (start)
                    state <= READ;
            end

            READ:
            begin
                state <= COMPUTE;
            end

            COMPUTE:
            begin
                if (processing_address == 2'b11)
                begin
                    state <= STORE;
                end
                else
                begin
                    processing_address <= processing_address + 1'b1;
                    state <= READ;
                end
            end

            STORE:
            begin
                state <= OUTPUT;
            end

            OUTPUT:
            begin
                state <= IDLE;
            end

            default:
            begin
                state <= IDLE;
                processing_address <= 2'b00;
            end

        endcase
    end
end


always @(*)
begin
    read_enable   = 1'b0;
    mac_enable    = 1'b0;
    output_enable = 1'b0;
    done          = 1'b0;

    case (state)

        IDLE:
        begin
        end

        READ:
        begin
            read_enable = 1'b1;
        end

        COMPUTE:
        begin
            mac_enable = 1'b1;
        end

        STORE:
        begin
            output_enable = 1'b1;
        end

        OUTPUT:
        begin
            done = 1'b1;
        end

        default:
        begin
            read_enable   = 1'b0;
            mac_enable    = 1'b0;
            output_enable = 1'b0;
            done          = 1'b0;
        end

    endcase
end

endmodule