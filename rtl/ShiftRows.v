module ShiftRows(
    input  wire [127:0] iData,
    output wire [127:0] oData
);

    wire [7:0] s[0:3][0:3];
    wire [7:0] so[0:3][0:3];

    genvar r, c;

    // Unpack (column-major)
    generate
        for (c = 0; c < 4; c = c + 1)
            for (r = 0; r < 4; r = r + 1)
                assign s[r][c] = iData[8*(4*c + r) +: 8];
    endgenerate

    // ShiftRows (FIPS-197)
    assign so[0][0] = s[0][0];
    assign so[0][1] = s[0][1];
    assign so[0][2] = s[0][2];
    assign so[0][3] = s[0][3];

    assign so[1][0] = s[1][1];
    assign so[1][1] = s[1][2];
    assign so[1][2] = s[1][3];
    assign so[1][3] = s[1][0];

    assign so[2][0] = s[2][2];
    assign so[2][1] = s[2][3];
    assign so[2][2] = s[2][0];
    assign so[2][3] = s[2][1];

    assign so[3][0] = s[3][3];
    assign so[3][1] = s[3][0];
    assign so[3][2] = s[3][1];
    assign so[3][3] = s[3][2];

    // Pack back (column-major)
    generate
        for (c = 0; c < 4; c = c + 1)
            for (r = 0; r < 4; r = r + 1)
                assign oData[8*(4*c + r) +: 8] = so[r][c];
    endgenerate

endmodule
