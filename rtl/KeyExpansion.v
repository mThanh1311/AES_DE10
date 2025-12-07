module KeyExpansion(
	input wire [127:0] iKey,
	output wire [1407:0] oRoundKeys
);

	wire [31:0] W[0:43];

//	integer i;
	
	// Original key 
	assign W[0] = iKey[127:96];
	assign W[1] = iKey[95:64];
	assign W[2] = iKey[63:32];
	assign W[3] = iKey[31:0];
	
	
	function automatic [31:0] Rcon (input integer r);
	begin
		case (r)
			1:  Rcon = 32'h01000000;
			2:  Rcon = 32'h02000000;
			3:  Rcon = 32'h04000000;
			4:  Rcon = 32'h08000000;
			5:  Rcon = 32'h10000000;
			6:  Rcon = 32'h20000000;
			7:  Rcon = 32'h40000000;
			8:  Rcon = 32'h80000000;
			9:  Rcon = 32'h1B000000;
			10: Rcon = 32'h36000000;
			default: Rcon = 32'h00000000;
		endcase
	end
	endfunction


	function automatic [31:0] RotWord (input [31:0] w);
	  begin
			RotWord = {w[23:0], w[31:24]};
	  end
	endfunction

	wire [127:0] sb_in  [1:10];
	wire [127:0] sb_out [1:10];
	wire [31:0]  subword[1:10];

	genvar sw;
	generate
		for (sw = 1; sw <= 10; sw = sw + 1) begin

			// Insert RotWord(W[4*sw - 1]) into [127:96], rest padded with zeros
			assign sb_in[sw] = { RotWord(W[4*sw - 1]), 96'b0 };

			// Reuse your SubBytes module
			SubBytes u_subbytes (
				 .iData(sb_in[sw]),
				 .oData(sb_out[sw])
			);

			// Extract SubWord = top 32 bits
			assign subword[sw] = sb_out[sw][127:96];
		end
	endgenerate

	
	genvar i;
	generate
		for (i = 4; i < 44; i = i + 1) begin
			if (i % 4 == 0) begin
				// Word with SubWord + Rcon
				assign W[i] = W[i-4]
							 ^ subword[i/4]
							 ^ Rcon(i/4);
			end else begin
				// Regular XOR with previous word
				assign W[i] = W[i-4] ^ W[i-1];
			end
		end
	endgenerate
	
	
	generate
		for (i = 0; i < 11; i = i + 1) begin 
			assign oRoundKeys[128*i +: 128] = { W[4*i], W[4*i+1], W[4*i+2], W[4*i+3] };
		end
	endgenerate
	
endmodule  