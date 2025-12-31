`timescale 1ns/1ps

module top_tb;

    // -------------------------------------------------
    // Clock / Reset
    // -------------------------------------------------
    reg clk;
    reg rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz
    end

    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // -------------------------------------------------
    // Avalon-MM signals
    // -------------------------------------------------
    reg         iChipSelect_n;
    reg         iWrite_n;
    reg         iRead_n;
    reg [5:0]   iAddress;
    reg [31:0]  iWriteData;
    reg [3:0]   iByteEnable;
    wire [31:0] oReadData;

    // -------------------------------------------------
    // DUT
    // -------------------------------------------------
    Top #(.KEY_SIZE(128)) dut (
        .iClk(clk),
        .iReset_n(rst_n),
        .iChipSelect_n(iChipSelect_n),
        .iWrite_n(iWrite_n),
        .iRead_n(iRead_n),
        .iAddress(iAddress),
        .iWriteData(iWriteData),
        .iByteEnable(iByteEnable),
        .oReadData(oReadData)
    );

    // -------------------------------------------------
    // Avalon-MM helper tasks
    // -------------------------------------------------
    task avalon_write(input [5:0] addr, input [31:0] data);
    begin
        @(posedge clk);
        iChipSelect_n <= 0;
        iWrite_n      <= 0;
        iRead_n       <= 1;
        iAddress      <= addr;
        iWriteData    <= data;
        iByteEnable   <= 4'b1111;

        @(posedge clk);
        iChipSelect_n <= 1;
        iWrite_n      <= 1;
    end
    endtask

    task avalon_read(input [5:0] addr, output [31:0] data);
    begin
        @(posedge clk);
        iChipSelect_n <= 0;
        iWrite_n      <= 1;
        iRead_n       <= 0;
        iAddress      <= addr;

        @(posedge clk);
        data = oReadData;
        iChipSelect_n <= 1;
        iRead_n       <= 1;
    end
    endtask

    // -------------------------------------------------
    // Test vector (NIST AES-128)
    // -------------------------------------------------
    reg [127:0] plaintext  = 128'h00112233445566778899AABBCCDDEEFF;
    reg [127:0] key        = 128'h000102030405060708090A0B0C0D0E0F;
    reg [127:0] expected_ct= 128'h69C4E0D86A7B0430D8CDB78070B4C55A;

    reg [31:0] ct0, ct1, ct2, ct3;
    reg [31:0] status;

    // -------------------------------------------------
    // Test sequence
    // -------------------------------------------------
    initial begin
        // Default bus idle
        iChipSelect_n = 1;
        iWrite_n      = 1;
        iRead_n       = 1;
        iAddress      = 0;
        iWriteData    = 0;
        iByteEnable   = 0;

        // Wait reset release
        @(posedge rst_n);
        $display("=== AES TOP TB START ===");

        // ---------------- Write plaintext ----------------
        avalon_write(6'h00, plaintext[31:0]);    // PT0
        avalon_write(6'h01, plaintext[63:32]);   // PT1
        avalon_write(6'h02, plaintext[95:64]);   // PT2
        avalon_write(6'h03, plaintext[127:96]);  // PT3

        // ---------------- Write key ----------------
        avalon_write(6'h04, key[31:0]);           // KEY0
        avalon_write(6'h05, key[63:32]);          // KEY1
        avalon_write(6'h06, key[95:64]);          // KEY2
        avalon_write(6'h07, key[127:96]);         // KEY3

        // ---------------- Start AES ----------------
        avalon_write(6'h0C, 32'h00000001);        // START

        // ---------------- Poll DONE ----------------
        do begin
            avalon_read(6'h0C, status);
        end while (status[1] == 0);

        $display("AES DONE");

        // ---------------- Read ciphertext ----------------
        avalon_read(6'h0D, ct0);
        avalon_read(6'h0E, ct1);
        avalon_read(6'h0F, ct2);
        avalon_read(6'h10, ct3);

        // ---------------- Check result ----------------
        if ({ct3, ct2, ct1, ct0} == expected_ct) begin
            $display("PASS: Ciphertext matches NIST vector");
        end else begin
            $display("FAIL!");
            $display("Expected: %h", expected_ct);
            $display("Got     : %h", {ct3, ct2, ct1, ct0});
        end

        $display("=== AES TOP TB END ===");
        #50;
        $stop;
    end

endmodule
