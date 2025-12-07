module SubBytes(
    input  wire [127:0] iData,
    output wire [127:0] oData
);

    wire [7:0] s_in [0:3][0:3];
    wire [7:0] s_out[0:3][0:3];

    genvar r, c;

    // Unpack AES state (column-major)
    generate
        for (c = 0; c < 4; c = c + 1) begin
            for (r = 0; r < 4; r = r + 1) begin
                assign s_in[r][c] = iData[8*(4*c + r) +: 8];
            end
        end
    endgenerate

    // Apply SBox to each byte
    generate
        for (c = 0; c < 4; c = c + 1) begin
            for (r = 0; r < 4; r = r + 1) begin
                SBox u_sbox (
                    .iData(s_in[r][c]),
                    .oData(s_out[r][c])
                );
            end
        end
    endgenerate

    // Pack back into 128-bit output
    generate
        for (c = 0; c < 4; c = c + 1)
            for (r = 0; r < 4; r = r + 1)
                assign oData[8*(4*c + r) +: 8] = s_out[r][c];
    endgenerate

endmodule
