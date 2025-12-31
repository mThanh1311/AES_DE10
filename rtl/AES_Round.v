module AES_Round (
    input  wire [127:0] iState,        // State input
    input  wire [127:0] iRoundKey,     // Round key (128-bit)
    input  wire         iFinalRound,   // 1 = final round (no MixColumns)
    output wire [127:0] oState         // State output
);

    // =================================================
    // SubBytes
    // =================================================
    wire [127:0] sb_out;

    SubBytes u_subbytes (
        .iData(iState),
        .oData(sb_out)
    );

    // =================================================
    // ShiftRows
    // =================================================
    wire [127:0] sr_out;

    ShiftRows u_shiftrows (
        .iData(sb_out),
        .oData(sr_out)
    );

    // =================================================
    // MixColumns (skipped in final round)
    // =================================================
    wire [127:0] mc_out;

    MixColumns u_mixcolumns (
        .iData(sr_out),
        .oData(mc_out)
    );

    // Select MixColumns or bypass (final round)
    wire [127:0] round_data;
    assign round_data = iFinalRound ? sr_out : mc_out;

    // =================================================
    // AddRoundKey (XOR)
    // =================================================
    assign oState = round_data ^ iRoundKey;

endmodule 