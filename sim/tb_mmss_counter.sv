`timescale 1ns/1ps

module tb_mmss_counter;

    reg clk_50mhz = 0;
    reg rst_p = 1;

    wire [3:0] mt, mo, st, so;

    reg  [3:0] decode_digit;
    wire [7:0] decoded_segments;

    integer checks = 0;

    always #10 clk_50mhz = ~clk_50mhz;

    mmss_counter #(
        .CLK_HZ(2)
    ) dut (
        .clk(clk_50mhz),
        .rst_p(rst_p),
        .minute_tens(mt),
        .minute_ones(mo),
        .second_tens(st),
        .second_ones(so)
    );

    sevenseg_decode decoder (
        .digit(decode_digit),
        .segments(decoded_segments)
    );

    task advance(input integer seconds);
        begin
            repeat(seconds * 2)
                @(posedge clk_50mhz);
            #1;
        end
    endtask

    task check_time(
        input integer emt,
        input integer emo,
        input integer est,
        input integer eso
    );
        begin
            if (mt !== emt ||
                mo !== emo ||
                st !== est ||
                so !== eso)
                $fatal(
                    1,
                    "time=%0d%0d:%0d%0d",
                    mt, mo, st, so
                );

            checks++;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mmss_counter);

        decode_digit = 0;
        #1;

        if (decoded_segments !== 8'b1111_1100)
            $fatal(1, "digit 0 decode");

        checks++;

        decode_digit = 9;
        #1;

        if (decoded_segments !== 8'b1111_0110)
            $fatal(1, "digit 9 decode");

        checks++;

        repeat(2)
            @(posedge clk_50mhz);

        rst_p = 0;

        check_time(0, 0, 0, 0);

        advance(10);
        check_time(0, 0, 1, 0);

        advance(50);
        check_time(0, 1, 0, 0);

        advance(3539);
        check_time(5, 9, 5, 9);

        advance(1);
        check_time(0, 0, 0, 0);

        $display(
            "LAB3_MMSS_PASS checks=%0d",
            checks
        );

        $finish;
    end

    initial begin
        #200000;
        $fatal(1, "timeout");
    end

endmodule
