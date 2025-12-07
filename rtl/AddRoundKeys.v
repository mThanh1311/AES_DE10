module AddRoundKeys(
	input [127:0] iState,
	input [127:0] iRoundKey,
	output [127:0] oState
);
	
	wire [7:0] s [0:3][0:3];
	wire [7:0] k [0:3][0:3];
	wire [7:0] so [3:0][3:0];
	
	genvar c,r;
	
	generate 
		for (c = 0; c < 4; c = c + 1) begin
			for (r = 0; r < 4; r = r + 1) begin
				assign s[r][c] = iState[8*(4*c + r) +: 8];
            assign k[r][c] = iRoundKey[8*(4*c + r) +: 8];
			end
		end
	endgenerate
	
	
	generate
		for (c = 0; c < 4; c = c + 1)
			for (r = 0; r < 4; r = r + 1)
				assign so[r][c] = s[r][c] ^ k[r][c]; // out = in ^ key
	endgenerate
	
	generate
		for (c = 0; c < 4; c = c + 1)
			for (r = 0; r < 4; r = r + 1)
				assign oState[8*(4*c + r) +: 8] = so[r][c];
	endgenerate
	
endmodule 