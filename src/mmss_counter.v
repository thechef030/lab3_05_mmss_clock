`timescale 1ns/1ps

module mmss_counter #(
    parameter integer CLK_HZ = 50_000_000
) (
    input  wire       clk,
    input  wire       rst_p,
    output reg  [3:0] minute_tens,
    output reg  [3:0] minute_ones,
    output reg  [3:0] second_tens,
    output reg  [3:0] second_ones
);

    localparam integer COUNT_WIDTH =
        (CLK_HZ < 2) ? 1 : $clog2(CLK_HZ);

    reg [COUNT_WIDTH-1:0] subsecond;

    always @(posedge clk or posedge rst_p) begin
        if (rst_p) begin
            subsecond   <= 0;

            minute_tens <= 0;
            minute_ones <= 0;

            second_tens <= 0;
            second_ones <= 0;
        end
        else if (subsecond == CLK_HZ - 1) begin
            subsecond <= 0;

            if (second_ones != 9)
                second_ones <= second_ones + 1'b1;
            else begin
                second_ones <= 0;

                if (second_tens != 5)
                    second_tens <= second_tens + 1'b1;
                else begin
                    second_tens <= 0;

                    if (minute_ones != 9)
                        minute_ones <= minute_ones + 1'b1;
                    else begin
                        minute_ones <= 0;

                        if (minute_tens != 5)
                            minute_tens <= minute_tens + 1'b1;
                        else
                            minute_tens <= 0;
                    end
                end
            end
        end
        else begin
            subsecond <= subsecond + 1'b1;
        end
    end

endmodule
