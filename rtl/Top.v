/*
AES Avalon-MM IP
- Address map (word addresses):
  0x00 - PT[0] (LSW)
  0x01 - PT[1]
  0x02 - PT[2]
  0x03 - PT[3] (MSW)
  0x04 - KEY[0]
  0x05 - KEY[1]
  0x06 - KEY[2]
  0x07 - KEY[3]
  0x08 - KEY[4]
  0x09 - KEY[5]
  0x0A - KEY[6]
  0x0B - KEY[7]
  0x0C - CONTROL/STATUS (bit0 = START write, read: [1]=DONE)
  0x0D - CT[0]
  0x0E - CT[1]
  0x0F - CT[2]
  0x10 - CT[3]

Notes:
- Plaintext and key are packed MSB-first when presented to AESCore (plaintext = {PT[3],PT[2],PT[1],PT[0]}).
- Writes support byte enables via iByteEnable when writing PT/KEY words.
*/
module Top #(
    parameter KEY_SIZE = 128
)(
    input  wire         iClk,
    input  wire         iReset_n,

    // Avalon MM Slave interface
    input  wire         iChipSelect_n,
    input  wire         iWrite_n,
    input  wire         iRead_n,
    input  wire [5:0]   iAddress,      
    input  wire [31:0]  iWriteData,
    input  wire [3:0]   iByteEnable,
    output reg  [31:0]  oReadData
);

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

    // Internal registers -----------------------------------
    reg [31:0] PT [0:3];      // Plaintext registers (word 0 = least-significant word)
    reg [31:0] KEY[0:7];     // Key words (supports up to 256-bit key)
    reg [31:0] CT [0:3];     // Ciphertext registers

    reg start_reg;           // write-set, auto-clear on done
    reg start_pulse;         // single-cycle pulse to AES core (generated)
    reg start_issued;        // indicates pulse already issued for current start
    reg done;
//    reg aes_done_d;          // delayed aes_done for edge detection

    // Write/Read enables
    wire wr = (~iChipSelect_n & ~iWrite_n);
    wire rd = (~iChipSelect_n & ~iRead_n);

    // Pack plaintext into 128-bit signal
    wire [127:0] plaintext = {PT[3], PT[2], PT[1], PT[0]};

    // Build key of parameterizable width
    wire [KEY_SIZE-1:0] key;
    generate
        if (KEY_SIZE == 128) begin
            assign key = {KEY[3], KEY[2], KEY[1], KEY[0]};
        end else if (KEY_SIZE == 192) begin
            assign key = {KEY[5], KEY[4], KEY[3], KEY[2], KEY[1], KEY[0]};
        end else begin
            assign key = {KEY[7], KEY[6], KEY[5], KEY[4], KEY[3], KEY[2], KEY[1], KEY[0]};
        end
    endgenerate

    // AES core outputs
    wire [127:0] cipher_out;
    wire aes_done;

    //---------------------------------------------------------
    // AES Core Instance
    //---------------------------------------------------------
    AESCore #(.KEY_SIZE(KEY_SIZE)) u_aes (
        .iClk(iClk),
        .iRst(~iReset_n),
        .iStart(start_pulse),
        .iPlaintext(plaintext),
        .iKey(key),
        .oCiphertext(cipher_out),
        .oDone(aes_done)
    );

    //---------------------------------------------------------
    // WRITE LOGIC
    //---------------------------------------------------------
    always @(posedge iClk or negedge iReset_n) begin
        if (!iReset_n) begin
            PT[0] <= 0; PT[1] <= 0; PT[2] <= 0; PT[3] <= 0;
            KEY[0] <= 0; KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[4] <= 0; KEY[5] <= 0; KEY[6] <= 0; KEY[7] <= 0;
            CT[0] <= 0; CT[1] <= 0; CT[2] <= 0; CT[3] <= 0;

            start_reg <= 1'b0;
            start_pulse <= 1'b0;
				start_issued <= 1'b0;
            done  <= 1'b0;
//            aes_done_d <= 1'b0;
        end
        else begin
            
            // Write registers (with byte-enable support)
            if (wr) begin
                case (iAddress)
                    ADDR_PT0: begin
                        // PT[0]
                        if (iByteEnable[0]) PT[0][7:0]   <= iWriteData[7:0];
                        if (iByteEnable[1]) PT[0][15:8]  <= iWriteData[15:8];
                        if (iByteEnable[2]) PT[0][23:16] <= iWriteData[23:16];
                        if (iByteEnable[3]) PT[0][31:24] <= iWriteData[31:24];
                    end
                    ADDR_PT1: begin
                        if (iByteEnable[0]) PT[1][7:0]   <= iWriteData[7:0];
                        if (iByteEnable[1]) PT[1][15:8]  <= iWriteData[15:8];
                        if (iByteEnable[2]) PT[1][23:16] <= iWriteData[23:16];
                        if (iByteEnable[3]) PT[1][31:24] <= iWriteData[31:24];
                    end
                    ADDR_PT2: begin
                        if (iByteEnable[0]) PT[2][7:0]   <= iWriteData[7:0];
                        if (iByteEnable[1]) PT[2][15:8]  <= iWriteData[15:8];
                        if (iByteEnable[2]) PT[2][23:16] <= iWriteData[23:16];
                        if (iByteEnable[3]) PT[2][31:24] <= iWriteData[31:24];
                    end
                    ADDR_PT3: begin
                        if (iByteEnable[0]) PT[3][7:0]   <= iWriteData[7:0];
                        if (iByteEnable[1]) PT[3][15:8]  <= iWriteData[15:8];
                        if (iByteEnable[2]) PT[3][23:16] <= iWriteData[23:16];
                        if (iByteEnable[3]) PT[3][31:24] <= iWriteData[31:24];
                    end

                    // KEY words (0..7) mapped to addresses 0x04..0x0B
                    ADDR_KEY0: begin
                        if (iByteEnable[0]) KEY[0][7:0]   <= iWriteData[7:0];
                        if (iByteEnable[1]) KEY[0][15:8]  <= iWriteData[15:8];
                        if (iByteEnable[2]) KEY[0][23:16] <= iWriteData[23:16];
                        if (iByteEnable[3]) KEY[0][31:24] <= iWriteData[31:24];
                    end
						  // For simplicity, KEY[1..7] are written as full 32-bit words.
						  // Byte-enable support can be extended similarly to KEY[0] if required.
						  
						  
                    ADDR_KEY1: KEY[1] <= iWriteData;
                    ADDR_KEY2: KEY[2] <= iWriteData;
                    ADDR_KEY3: KEY[3] <= iWriteData;
                    ADDR_KEY4: KEY[4] <= iWriteData;
                    ADDR_KEY5: KEY[5] <= iWriteData;
                    ADDR_KEY6: KEY[6] <= iWriteData;
                    ADDR_KEY7: KEY[7] <= iWriteData;

                    // Control register at 0x0C
                    ADDR_CTRL: begin
                        // bit0 = START (write to trigger)
                        if (iWriteData[CTRL_START_BIT]) begin
                            start_reg <= 1'b1;
                            done <= 1'b0;        // clear done when starting
                        end
                    end
                endcase
            end

            // Issue single-cycle start pulse (after a write sets start_reg)
            if (start_reg && !start_issued) begin
                start_pulse <= 1'b1;
                start_issued <= 1'b1;
            end else begin
                start_pulse <= 1'b0;
            end

            // If AES core finished computation
            if (aes_done) begin
                done <= 1'b1;

                // latch cipher output
                {CT[3], CT[2], CT[1], CT[0]} <= cipher_out;

                start_reg <= 0;    // auto-clear START
                start_issued <= 0;


            end

            // Delay register for edge detection
//            aes_done_d <= aes_done;

        end
    end

    //---------------------------------------------------------
    // READ LOGIC
    //---------------------------------------------------------
    always @(*) begin
        if (rd) begin
            case (iAddress)
                ADDR_PT0: oReadData = PT[0];
                ADDR_PT1: oReadData = PT[1];
                ADDR_PT2: oReadData = PT[2];
                ADDR_PT3: oReadData = PT[3];

                ADDR_KEY0: oReadData = KEY[0];
                ADDR_KEY1: oReadData = KEY[1];
                ADDR_KEY2: oReadData = KEY[2];
                ADDR_KEY3: oReadData = KEY[3];
                ADDR_KEY4: oReadData = KEY[4];
                ADDR_KEY5: oReadData = KEY[5];
                ADDR_KEY6: oReadData = KEY[6];
                ADDR_KEY7: oReadData = KEY[7];

                // Control/status register
                // [0] = START (write), [1] = DONE
                ADDR_CTRL: oReadData = {30'd0, done, start_reg};

                ADDR_CT0: oReadData = CT[0];
                ADDR_CT1: oReadData = CT[1];
                ADDR_CT2: oReadData = CT[2];
                ADDR_CT3: oReadData = CT[3];


                default: oReadData = 32'hDEADBEEF;
            endcase
        end else begin
            oReadData = 32'h0;
        end
    end
endmodule