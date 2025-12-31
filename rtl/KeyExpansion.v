module KeyExpansion #(
    parameter KEY_SIZE = 128
)(
    input  wire [KEY_SIZE-1:0] iKey,
    output wire [128*((
        (KEY_SIZE==128)?11:
        (KEY_SIZE==192)?13:
        (KEY_SIZE==256)?15:11
    ))-1:0] oRoundKeys
);

    // =================================================
    // Derived AES parameters
    // =================================================
    localparam integer Nk =
        (KEY_SIZE == 128) ? 4 :
        (KEY_SIZE == 192) ? 6 :
        (KEY_SIZE == 256) ? 8 : 4;

    localparam integer Nr =
        (KEY_SIZE == 128) ? 10 :
        (KEY_SIZE == 192) ? 12 :
        (KEY_SIZE == 256) ? 14 : 10;

    localparam integer TOTAL_WORDS = 4 * (Nr + 1);

    // =================================================
    // Word array
    // =================================================
    wire [31:0] w [0:TOTAL_WORDS-1];

    // =================================================
    // Load initial key
    // =================================================
    genvar k;
    generate
        for (k = 0; k < Nk; k = k + 1) begin : LOAD_KEY
            assign w[k] = iKey[KEY_SIZE-1 - 32*k -: 32];
        end
    endgenerate

    // =================================================
    // RCON
    // =================================================
    function automatic [7:0] rcon;
        input integer round;
        begin
            case (round)
                1:  rcon = 8'h01;
                2:  rcon = 8'h02;
                3:  rcon = 8'h04;
                4:  rcon = 8'h08;
                5:  rcon = 8'h10;
                6:  rcon = 8'h20;
                7:  rcon = 8'h40;
                8:  rcon = 8'h80;
                9:  rcon = 8'h1b;
                10: rcon = 8'h36;
                default: rcon = 8'h00;
            endcase
        end
    endfunction

    function automatic [31:0] rotword;
        input [31:0] w;
        begin
            rotword = { w[23:0], w[31:24] };
        end
    endfunction

    // =================================================
    // Key expansion
    // =================================================
    genvar i;
    generate
        for (i = Nk; i < TOTAL_WORDS; i = i + 1) begin : GEN_KEY

            if (i % Nk == 0) begin : GEN_G
                wire [31:0] rot;
                wire [7:0] sb0, sb1, sb2, sb3;

                assign rot = rotword(w[i-1]);

                SBox s0 (.iData(rot[31:24]), .oData(sb0));
                SBox s1 (.iData(rot[23:16]), .oData(sb1));
                SBox s2 (.iData(rot[15:8 ]), .oData(sb2));
                SBox s3 (.iData(rot[7:0  ]), .oData(sb3));

                assign w[i] = w[i-Nk] ^
                              { sb0 ^ rcon(i/Nk), sb1, sb2, sb3 };

            end else if (KEY_SIZE == 256 && i % Nk == 4) begin : GEN_256
                wire [7:0] sb0, sb1, sb2, sb3;

                SBox s0 (.iData(w[i-1][31:24]), .oData(sb0));
                SBox s1 (.iData(w[i-1][23:16]), .oData(sb1));
                SBox s2 (.iData(w[i-1][15:8 ]), .oData(sb2));
                SBox s3 (.iData(w[i-1][7:0  ]), .oData(sb3));

                assign w[i] = w[i-Nk] ^ { sb0, sb1, sb2, sb3 };

            end else begin : GEN_XOR
                assign w[i] = w[i-Nk] ^ w[i-1];
            end
        end
    endgenerate

    // =================================================
    // Pack round keys
    // =================================================
    genvar j;
    generate
        for (j = 0; j < Nr+1; j = j + 1) begin : GEN_OUT
            assign oRoundKeys[128*(Nr-j+1)-1 -: 128] =
                { w[4*j], w[4*j+1], w[4*j+2], w[4*j+3] };
        end
    endgenerate

endmodule
