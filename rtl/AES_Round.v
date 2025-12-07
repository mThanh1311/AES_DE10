module AES_Round(
	input  wire [127:0] iState,        // state input
	input  wire [127:0] iRoundKey,     // round key for this round
	input  wire         iFinalRound,   // =1 for the last round (disable MixColumns)
	output wire [127:0] oState         // output state after this round
	);
	
	
	 wire [127:0] sb_out;

    SubBytes u_subbytes (
        .iData(iState),
        .oData(sb_out)
    );
	 
	 
    wire [127:0] sr_out;

    ShiftRows u_shiftrows (
        .iData(sb_out),
        .oData(sr_out)
    );

	
    wire [127:0] mc_out;
    wire [127:0] mc_or_sr;      // mux output

    MixColumns u_mixcolumns (
        .iData(sr_out),
        .oData(mc_out)
    );

    // If final round → bypass MixColumns
    assign mc_or_sr = (iFinalRound) ? sr_out : mc_out;
	

    AddRoundKeys u_addroundkey (
        .iState   (mc_or_sr),
        .iRoundKey(iRoundKey),
        .oState   (oState)
    );	

endmodule 