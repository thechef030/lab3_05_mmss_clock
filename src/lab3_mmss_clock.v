`timescale 1ns/1ps

module lab3_mmss_clock #(
    parameter integer CLK_HZ  = 50_000_000,
    parameter integer SCAN_HZ = 4_000
) (
    input  wire       clk_50mhz,
    input  wire       rst_p,
    output reg  [7:0] seg_data,
    output reg  [7:0] seg_com
);

    wire [3:0] mt, mo, st, so;
    wire [7:0] seg_mt, seg_mo, seg_st, seg_so;

    localparam integer SCAN_CYCLES = CLK_HZ / SCAN_HZ;
    localparam integer SCAN_WIDTH =
        (SCAN_CYCLES < 2) ? 1 : $clog2(SCAN_CYCLES);

    reg [SCAN_WIDTH-1:0] scan_count;
    reg [1:0] scan_select;

    mmss_counter #(
        .CLK_HZ(CLK_HZ)
    ) u_counter (
        .clk(clk_50mhz),
        .rst_p(rst_p),
        .minute_tens(mt),
        .minute_ones(mo),
        .second_tens(st),
        .second_ones(so)
    );

    sevenseg_decode u_mt(
        .digit(mt),
        .segments(seg_mt)
    );

    sevenseg_decode u_mo(
        .digit(mo),
        .segments(seg_mo)
    );

    sevenseg_decode u_st(
        .digit(st),
        .segments(seg_st)
    );

    sevenseg_decode u_so(
        .digit(so),
        .segments(seg_so)
    );

    always @(posedge clk_50mhz or posedge rst_p) begin
        if (rst_p) begin
            scan_count  <= 0;
            scan_select <= 0;
        end
        else if (scan_count == SCAN_CYCLES - 1) begin
            scan_count  <= 0;
            scan_select <= scan_select + 1'b1;
        end
        else begin
            scan_count <= scan_count + 1'b1;
        end
    end

    always @* begin
        seg_com  = 8'b1111_1111;
        seg_data = 8'b0000_0000;

        case (scan_select)
            2'd0: begin
                seg_com  = 8'b1111_0111;
                seg_data = seg_mt;
            end

            2'd1: begin
                seg_com  = 8'b1111_1011;
                seg_data = seg_mo | 8'b0000_0001;
            end

            2'd2: begin
                seg_com  = 8'b1111_1101;
                seg_data = seg_st;
            end

            default: begin
                seg_com  = 8'b1111_1110;
                seg_data = seg_so;
            end
        endcase
    end

endmodule
