module MixColumns(
	input wire [127:0] iData,
	output wire [127:0] oData
);
	
	wire [7:0] s [3:0][3:0]; // 4x4 
	wire [7:0] so[3:0][3:0];
	
	genvar r, c;
	
	// generate 4x4 matrix from 128-bit input Data
	generate 
		for (c = 0; c < 4; c = c + 1) begin
			for (r = 0; r < 4; r = r + 1) begin
				assign s[r][c] = iData[8*(4*c + r) +: 8];
			end
		end
	endgenerate 
	
	// Mul 2
	function automatic [7:0] mul2 (input [7:0] x);
		begin
			mul2 = xtime(x);
		end
	endfunction
	
	// Mul 3
	function automatic [7:0] mul3 (input [7:0] x);
		begin
			mul3 = xtime(x) ^ x;
		end
	endfunction
	
	
	function automatic [7:0] xtime (input [7:0] x);
	begin
		// Shift left and XOR with irreducible polynomial 0x1B with MSB bit = 1'b1
		xtime = {x[6:0], 1'b0} ^ (8'h1B & {8{x[7]}});
	end
	endfunction 
	
	
	// Matrix MDS
	generate 
		for (c = 0; c < 4; c = c + 1) begin
			assign so[0][c] =  mul2(s[0][c])  ^  mul3(s[1][c])  ^  s[2][c]        ^  s[3][c];
			assign so[1][c] =  s[0][c]        ^  mul2(s[1][c])  ^  mul3(s[2][c])  ^  s[3][c];
			assign so[2][c] =  s[0][c]        ^  s[1][c]        ^  mul2(s[2][c])  ^  mul3(s[3][c]);
			assign so[3][c] =  mul3(s[0][c])  ^  s[1][c]        ^  s[2][c]        ^  mul2(s[3][c]);
		end
	endgenerate
	
	
	
	 generate
	  for (c = 0; c < 4; c = c + 1)
			for (r = 0; r < 4; r = r + 1)
				 assign oData[8*(4*c + r) +: 8] = so[r][c];
	 endgenerate
	 
endmodule 