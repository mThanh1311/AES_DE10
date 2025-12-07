`timescale 1ns/1ps 
module AES_core_tb;

    reg         clk;
    reg         rst;
    reg         start;

    reg  [127:0] plaintext;
    reg  [127:0] key;

    wire [127:0] ciphertext;
    wire         done;

    // Instantiate AES core
    AES_core uut (
        .iClk(clk),
        .iRst(rst),
        .iStart(start),
        .iPlaintext(plaintext),
        .iKey(key),
        .oCiphertext(ciphertext),
        .oDone(done)
    );

    //-------------------------------------------------------
    // Clock generation: 10ns period
    //-------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //-------------------------------------------------------
    // Test sequence
    //-------------------------------------------------------
    initial begin
        $display("==== AES Core Testbench Start ====");

        // RESET
        rst = 1;
        start = 0;
        plaintext = 0;
        key = 0;
        #20;

        rst = 0;

        //---------------------------------------------------
        // Load test vectors (FIPS-197)
        //---------------------------------------------------
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        // Start encryption
        $display("[%0t ns] Start AES encryption", $time);
        start = 1;
        #10;
        start = 0;

        //---------------------------------------------------
        // Wait for AES done signal
        //---------------------------------------------------
        wait(done == 1);

        //---------------------------------------------------
        // Display results
        //---------------------------------------------------
        $display("[%0t ns] AES encryption DONE", $time);
        $display("Ciphertext = %032h", ciphertext);

        //---------------------------------------------------
        // Compare with expected result
        //---------------------------------------------------
        if (ciphertext == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("TEST PASSED: Ciphertext matches expected value.");
        else begin
            $display("TEST FAILED!");
            $display("Expected:  69c4e0d86a7b0430d8cdb78070b4c55a");
            $display("Got:       %032h", ciphertext);
        end

        $display("==== AES Core Testbench End ====");
        #20 $finish;
    end

endmodule 