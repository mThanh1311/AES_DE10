module SubBytes(
    input  wire [127:0] iData,
    output wire [127:0] oData
);

    // intermediate flat bus for 16 SBox outputs
    wire [127:0] sb_flat;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : INST_SBOX 
            // connect byte i: iData[127-8*i -: 8] -> SBox -> sb_flat[127-8*i -: 8]
            SBox i_sbox (
                .iData(iData[127 - 8*i -: 8]),
                .oData(sb_flat[127 - 8*i -: 8])
            );
        end
    endgenerate

    // output is concatenation of SBox outputs
    assign oData = sb_flat;

endmodule