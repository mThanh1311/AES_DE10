module MixColumns(
	input wire [127:0] iData,
	output wire [127:0] oData
);

	// split into bytes (MSB-first: byte0 = iData[127:120])
	wire [7:0] b [0:15];
	
	// compute each column
	wire [7:0] out_byte [0:15];

	
	genvar i;
	generate
	  for (i = 0; i < 16; i = i + 1) begin : SPLIT
			assign b[i] = iData[127 - 8*i -: 8];
	  end
	endgenerate
	

	// xtime: multiply by 2 in GF(2^8) = mul2
	function [7:0] xtime;
	  input [7:0] x;
	  begin
			xtime = (x[7] ? ((x << 1) ^ 8'h1b) : (x << 1));
	  end
	endfunction
	
	
    // multiply by 3 = xtime(x) ^ x
    function [7:0] mul3;
        input [7:0] x;
        begin
            mul3 = xtime(x) ^ x;
        end
    endfunction
	 
	 
	 genvar c;
	 generate 
		for (c = 0; c < 16; c = c + 4) begin : OUT_BYTES 
			assign out_byte[c] = xtime(b[c]) ^ mul3(b[c+1]) ^ b[c+2] ^ b[c+3];
			assign out_byte[c+1] = b[c] ^ xtime(b[c+1]) ^ mul3(b[c+2]) ^ b[c+3];
			assign out_byte[c+2] = b[c] ^ b[c+1] ^ xtime(b[c+2]) ^ mul3(b[c+3]);
			assign out_byte[c+3] = mul3(b[c]) ^ b[c+1] ^ b[c+2] ^ xtime(b[c+3]);
		end
	 endgenerate 
	 
	 genvar j;
	 
	 generate 
		for (j = 0; j < 16; j = j + 1) begin : OUT_DATA
			assign oData[127 - j*8 -: 8] = out_byte[j];
		end
	 endgenerate
	 
endmodule 