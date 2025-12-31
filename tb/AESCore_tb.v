`timescale 1ns/1ps
module AESCore_tb;

    // =====================================================
    // Clock & reset
    // =====================================================
    reg clk;
    reg rst;
    reg start;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns period
    end

    // =====================================================
    // -------- AES-192 signals --------
    // =====================================================
    reg  [127:0] pt192;
    reg  [191:0] key192;
    wire [127:0] ct192;
    wire         done192;

    AESCore #(
        .KEY_SIZE(192)
    ) dut192 (
        .iClk(clk),
        .iRst(rst),
        .iStart(start),
        .iPlaintext(pt192),
        .iKey(key192),
        .oCiphertext(ct192),
        .oDone(done192)
    );


    // =====================================================
    // Test sequence
    // =====================================================
    initial begin
        $display("\n================ AES CORE TEST =================");

        // ---------------- RESET ----------------
        rst   = 1;
        start = 0;

        pt192 = 0; key192 = 0;

        #50;

        // =================================================
        // AES-192 test (FIPS-197)
        // =================================================
        pt192  = 128'h00112233445566778899aabbccddeeff;
        key192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;

        #20;
        $display("\n[%0t] Start AES-192", $time);
        start = 1; 
		  #10; 
		  start = 0;

		  #20;
        wait (done192);
		  
        $display("[%0t] AES-192 DONE", $time);
        $display("Ciphertext = %032h", ct192);

        if (ct192 == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
            $display("AES-192 PASS");
        else
            $display("AES-192 FAIL");


        $display("\n================ TEST END =================\n");
        #50;
        $finish;
    end

endmodule
