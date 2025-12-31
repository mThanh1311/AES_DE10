module AddRoundKey (
    input  wire [127:0] iState,
    input  wire [127:0] iRoundKey,
    output wire [127:0] oState
);
    assign oState = iState ^ iRoundKey;
endmodule
