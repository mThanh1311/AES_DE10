module AES (
    input  wire         iClk,
    input  wire         iReset_n,

    // Avalon MM Slave interface
    input  wire         iChipSelect_n,
    input  wire         iWrite_n,
    input  wire         iRead_n,
    input  wire [5:0]   iAddress,      // enough to cover 0x00–0x30
    input  wire [31:0]  iWriteData,
    output reg  [31:0]  oReadData
);

    // Internal registers -----------------------------------
    reg [31:0] PT [0:3];      // Plaintext registers
    reg [31:0] KEY[0:3];      // Key registers
    reg [31:0] CT [0:3];       // Ciphertext registers

    reg start;
    reg done;

    // Write/Read enables
    wire wr = (~iChipSelect_n & ~iWrite_n);
    wire rd = (~iChipSelect_n & ~iRead_n);

    // Pack plaintext and key into 128-bit signals
    wire [127:0] plaintext = {PT[3], PT[2], PT[1], PT[0]};
    wire [127:0] key        = {KEY[3], KEY[2], KEY[1], KEY[0]};

    // AES core outputs
    wire [127:0] cipher_out;
    wire aes_done;

    //---------------------------------------------------------
    // AES Core Instance
    //---------------------------------------------------------
    AES_core u_aes (
        .iClk(iClk),
        .iRst(~iReset_n),
        .iStart(start),
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
            KEY[0] <= 0; KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;
            CT[0] <= 0; CT[1] <= 0; CT[2] <= 0; CT[3] <= 0;

            start <= 0;
            done  <= 0;
        end
        else begin
            
            // Write registers
            if (wr) begin
                case (iAddress)
                    6'h00: PT[0] <= iWriteData;
                    6'h01: PT[1] <= iWriteData;
                    6'h02: PT[2] <= iWriteData;
                    6'h03: PT[3] <= iWriteData;

                    6'h04: KEY[0] <= iWriteData;
                    6'h05: KEY[1] <= iWriteData;
                    6'h06: KEY[2] <= iWriteData;
                    6'h07: KEY[3] <= iWriteData;

                    6'h08: begin
                        start <= iWriteData[0];      // bit0 = START
                    end
                endcase
            end

            // If AES core finished computation
            if (aes_done) begin
                done <= 1;

                // latch cipher output
                {CT[3], CT[2], CT[1], CT[0]} <= cipher_out;

                start <= 0;    // auto-clear START
            end

            // Clear DONE when start is activated again
            if (start)
                done <= 0;
        end
    end

    //---------------------------------------------------------
    // READ LOGIC
    //---------------------------------------------------------
    always @(*) begin
        if (rd) begin
            case (iAddress)
                6'h00: oReadData = PT[0];
                6'h01: oReadData = PT[1];
                6'h02: oReadData = PT[2];
                6'h03: oReadData = PT[3];

                6'h04: oReadData = KEY[0];
                6'h05: oReadData = KEY[1];
                6'h06: oReadData = KEY[2];
                6'h07: oReadData = KEY[3];

                6'h08: oReadData = {30'd0, done, start};

                6'h09: oReadData = CT[0];
                6'h0A: oReadData = CT[1];
                6'h0B: oReadData = CT[2];
                6'h0C: oReadData = CT[3];

                default: oReadData = 32'hDEADBEEF;
            endcase
        end else begin
            oReadData = 32'h0;
        end
    end

endmodule
