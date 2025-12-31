`timescale 1ns/1ps
// Simple Avalon-MM testbench for AES IP
// Address map (word addresses):
// 0x00 - PT[0] (LSW)
// 0x01 - PT[1]
// 0x02 - PT[2]
// 0x03 - PT[3] (MSW)
// 0x04 - KEY[0]
// 0x05 - KEY[1]
// 0x06 - KEY[2]
// 0x07 - KEY[3]
// 0x08 - KEY[4]
// 0x09 - KEY[5]
// 0x0A - KEY[6]
// 0x0B - KEY[7]
// 0x0C - CONTROL/STATUS (bit0 = START write, read: [1]=DONE)
// 0x0D - CT[0]
// 0x0E - CT[1]
// 0x0F - CT[2]
// 0x10 - CT[3]

module AES_tb;
    reg clk = 0;
    always #5 clk = ~clk;

	 reg rst_n;
	// per-instance bus signals are declared below (cs_n128, cs_n192, cs_n256, etc)
    // Address map localparams (word addresses)
    localparam ADDR_PT0  = 6'h00;
    localparam ADDR_PT1  = 6'h01;
    localparam ADDR_PT2  = 6'h02;
    localparam ADDR_PT3  = 6'h03;

    localparam ADDR_KEY0 = 6'h04;
    localparam ADDR_KEY1 = 6'h05;
    localparam ADDR_KEY2 = 6'h06;
    localparam ADDR_KEY3 = 6'h07;
    localparam ADDR_KEY4 = 6'h08;
    localparam ADDR_KEY5 = 6'h09;
    localparam ADDR_KEY6 = 6'h0A;
    localparam ADDR_KEY7 = 6'h0B;

    localparam ADDR_CTRL  = 6'h0C; // control/status
    localparam CTRL_START_BIT = 0;
    localparam CTRL_DONE_BIT  = 1;

    localparam ADDR_CT0   = 6'h0D;
    localparam ADDR_CT1   = 6'h0E;
    localparam ADDR_CT2   = 6'h0F;
    localparam ADDR_CT3   = 6'h10;

    // Avalon signals for AES-128
    reg cs_n128;
    reg write_n128;
    reg read_n128;
    reg [5:0] addr128;
    reg [31:0] wdata128;
    reg [3:0] byteenable128;
    wire [31:0] rdata128;

    // Avalon signals for AES-192
    reg cs_n192;
    reg write_n192;
    reg read_n192;
    reg [5:0] addr192;
    reg [31:0] wdata192;
    reg [3:0] byteenable192;
    wire [31:0] rdata192;

    // Avalon signals for AES-256
    reg cs_n256;
    reg write_n256;
    reg read_n256;
    reg [5:0] addr256;
    reg [31:0] wdata256;
    reg [3:0] byteenable256;
    wire [31:0] rdata256;

    // Capture ciphertexts for checks
    reg [127:0] ct128;
    reg [127:0] ct192;
    reg [127:0] ct256;

    Top #(.KEY_SIZE(128)) dut128 (
        .iClk(clk),
        .iReset_n(rst_n),
        .iChipSelect_n(cs_n128),
        .iWrite_n(write_n128),
        .iRead_n(read_n128),
        .iAddress(addr128),
        .iWriteData(wdata128),
        .iByteEnable(byteenable128),
        .oReadData(rdata128)
    );

    Top #(.KEY_SIZE(192)) dut192 (
        .iClk(clk),
        .iReset_n(rst_n),
        .iChipSelect_n(cs_n192),
        .iWrite_n(write_n192),
        .iRead_n(read_n192),
        .iAddress(addr192),
        .iWriteData(wdata192),
        .iByteEnable(byteenable192),
        .oReadData(rdata192)
    );

    Top #(.KEY_SIZE(256)) dut256 (
        .iClk(clk),
        .iReset_n(rst_n),
        .iChipSelect_n(cs_n256),
        .iWrite_n(write_n256),
        .iRead_n(read_n256),
        .iAddress(addr256),
        .iWriteData(wdata256),
        .iByteEnable(byteenable256),
        .oReadData(rdata256)
    );

    // ----------------- AES-128 bus helpers -----------------
    task write_word128(input [5:0] a, input [31:0] d);
    begin
        @(negedge clk);
        cs_n128 = 0; write_n128 = 0; read_n128 = 1; addr128 = a; wdata128 = d; byteenable128 = 4'b1111;
        @(negedge clk);
        cs_n128 = 1; write_n128 = 1; read_n128 = 1; addr128 = ADDR_PT0; wdata128 = 32'h0; byteenable128 = 4'b0000; 
    end
    endtask

    task read_word128(input [5:0] a);
    begin
        @(negedge clk);
        cs_n128 = 0; write_n128 = 1; read_n128 = 0; addr128 = a; byteenable128 = 4'b0000;
        @(negedge clk);
        cs_n128 = 1; write_n128 = 1; read_n128 = 1; addr128 = ADDR_PT0;
    end
    endtask

    // ----------------- AES-192 bus helpers -----------------
    task write_word192(input [5:0] a, input [31:0] d);
    begin
        @(negedge clk);
        cs_n192 = 0; write_n192 = 0; read_n192 = 1; addr192 = a; wdata192 = d; byteenable192 = 4'b1111;
        @(negedge clk);
        cs_n192 = 1; write_n192 = 1; read_n192 = 1; addr192 = ADDR_PT0; wdata192 = 32'h0; byteenable192 = 4'b0000; 
    end
    endtask

    task read_word192(input [5:0] a);
    begin
        @(negedge clk);
        cs_n192 = 0; write_n192 = 1; read_n192 = 0; addr192 = a; byteenable192 = 4'b0000;
        @(negedge clk);
        cs_n192 = 1; write_n192 = 1; read_n192 = 1; addr192 = ADDR_PT0;
    end
    endtask

    // ----------------- AES-256 bus helpers -----------------
    task write_word256(input [5:0] a, input [31:0] d);
    begin
        @(negedge clk);
        cs_n256 = 0; write_n256 = 0; read_n256 = 1; addr256 = a; wdata256 = d; byteenable256 = 4'b1111;
        @(negedge clk);
        cs_n256 = 1; write_n256 = 1; read_n256 = 1; addr256 = ADDR_PT0; wdata256 = 32'h0; byteenable256 = 4'b0000; 
    end
    endtask

    task read_word256(input [5:0] a);
    begin
        @(negedge clk);
        cs_n256 = 0; write_n256 = 1; read_n256 = 0; addr256 = a; byteenable256 = 4'b0000;
        @(negedge clk);
        cs_n256 = 1; write_n256 = 1; read_n256 = 1; addr256 = ADDR_PT0;
    end
    endtask

    initial begin
        $display("\n===== AES Avalon IP TB =====");
        rst_n = 0;
        // init instance buses
        cs_n128 = 1; write_n128 = 1; read_n128 = 1; addr128 = 0; wdata128 = 0; byteenable128 = 0;
        cs_n192 = 1; write_n192 = 1; read_n192 = 1; addr192 = 0; wdata192 = 0; byteenable192 = 0;
        cs_n256 = 1; write_n256 = 1; read_n256 = 1; addr256 = 0; wdata256 = 0; byteenable256 = 0;
        #20; rst_n = 1;

        // Test vector (FIPS)
        // PT = 0x00112233445566778899aabbccddeeff
        // Key = 0x00010203...0e0f
        // Expected CT = 0x69c4e0d86a7b0430d8cdb78070b4c55a

        // Write plaintext words (LSW first) to AES-128
        write_word128(ADDR_PT0, 32'hccddeeff); // PT[0] low dword (depends on host endianness - adapt if needed)
        write_word128(ADDR_PT1, 32'h8899aabb);
        write_word128(ADDR_PT2, 32'h44556677);
        write_word128(ADDR_PT3, 32'h00112233); // PT[3]

        // Write key (128-bit)
        write_word128(ADDR_KEY0, 32'h0c0d0e0f);
        write_word128(ADDR_KEY1, 32'h08090a0b);
        write_word128(ADDR_KEY2, 32'h04050607);
        write_word128(ADDR_KEY3, 32'h00010203);

        // Start encryption (bit0 = START)
        write_word128(ADDR_CTRL, 32'h00000001);

        // Poll status register until DONE (bit1) is set
			$display("Waiting for done (128)...");

			while (rdata128[CTRL_DONE_BIT] == 1'b0) begin
				 read_word128(ADDR_CTRL);
				 #10;
			end

			$display("Done (128)");
        // Read ciphertext
        read_word128(ADDR_CT0); ct128[31:0]   = rdata128;
        read_word128(ADDR_CT1); ct128[63:32]  = rdata128;
        read_word128(ADDR_CT2); ct128[95:64]  = rdata128;
        read_word128(ADDR_CT3); ct128[127:96] = rdata128;
        if (ct128 == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("AES-128 PASS");
        else
            $display("AES-128 FAIL (ct=%032h)", ct128);
        // ================= AES-192 =================
        // Write plaintext (same)
        write_word192(ADDR_PT0, 32'hccddeeff);
        write_word192(ADDR_PT1, 32'h8899aabb);
        write_word192(ADDR_PT2, 32'h44556677);
        write_word192(ADDR_PT3, 32'h00112233);

        // Write 192-bit key. Mapping: KEY[0] @ ADDR_KEY0 is LSW
        // key = 00010203 04050607 08090a0b 0c0d0e0f 10111213 14151617
        write_word192(ADDR_KEY4, 32'h14151617);
        write_word192(ADDR_KEY3, 32'h10111213);
        write_word192(ADDR_KEY2, 32'h0c0d0e0f);
        write_word192(ADDR_KEY1, 32'h08090a0b);
        write_word192(ADDR_KEY0, 32'h04050607);
        write_word192(ADDR_KEY5, 32'h00010203);

        // Start AES-192
        write_word192(ADDR_CTRL, 32'h00000001);
        $display("Waiting for done (192)...");
		  
			while (rdata192[CTRL_DONE_BIT] == 1'b0) begin
				 read_word192(ADDR_CTRL);
				 #10;
			end

         $display("Done (192)");
        // Read CT
        read_word192(ADDR_CT0); ct192[31:0]   = rdata192;
        read_word192(ADDR_CT1); ct192[63:32]  = rdata192;
        read_word192(ADDR_CT2); ct192[95:64]  = rdata192;
        read_word192(ADDR_CT3); ct192[127:96] = rdata192;
        if (ct192 == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
            $display("AES-192 PASS");
        else
            $display("AES-192 FAIL (ct=%032h)", ct192);

        // ================= AES-256 =================
        // Write plaintext (same)
        write_word256(ADDR_PT0, 32'hccddeeff);
        write_word256(ADDR_PT1, 32'h8899aabb);
        write_word256(ADDR_PT2, 32'h44556677);
        write_word256(ADDR_PT3, 32'h00112233);

        // Write 256-bit key. Mapping: KEY[0] @ ADDR_KEY0 is LSW
        // key = 00010203 04050607 08090a0b 0c0d0e0f 10111213 14151617 18191a1b 1c1d1e1f
        write_word256(ADDR_KEY7, 32'h1c1d1e1f);
        write_word256(ADDR_KEY6, 32'h18191a1b);
        write_word256(ADDR_KEY5, 32'h14151617);
        write_word256(ADDR_KEY4, 32'h10111213);
        write_word256(ADDR_KEY3, 32'h0c0d0e0f);
        write_word256(ADDR_KEY2, 32'h08090a0b);
        write_word256(ADDR_KEY1, 32'h04050607);
        write_word256(ADDR_KEY0, 32'h00010203);

        // Start AES-256
        write_word256(ADDR_CTRL, 32'h00000001);
        $display("Waiting for done (256)...");
			while (rdata256[CTRL_DONE_BIT] == 1'b0) begin
				 read_word256(ADDR_CTRL);
				 #10;
			end
			$display("Done (256)");

        // Read CT
        read_word256(ADDR_CT0); ct256[31:0]   = rdata256;
        read_word256(ADDR_CT1); ct256[63:32]  = rdata256;
        read_word256(ADDR_CT2); ct256[95:64]  = rdata256;
        read_word256(ADDR_CT3); ct256[127:96] = rdata256;
        if (ct256 == 128'h8ea2b7ca516745bfeafc49904b496089)
            $display("AES-256 PASS");
        else
            $display("AES-256 FAIL (ct=%032h)", ct256);

        $display("\n===== TB END =====\n");
        #50; $finish;
    end
endmodule

