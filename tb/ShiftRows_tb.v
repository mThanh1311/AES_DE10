module ShiftRows_tb;
	reg [127:0] in_data;
	wire [127:0] out_data;
	
	ShiftRows u_shiftrows(
			.iData(in_data),
			.oData(out_data)
	);
	
	initial begin
	
		 $display("===== TEST ShiftRows =====");

		 in_data    = 128'h8293c31bfc33f5c4eeacea4bc1281663;

		 #10;

		 $display("DUT     = %h", out_data);
		 $display("Golden  = 128'hfcac161bee28c3c4c193f54b8233ea63");

		 if (out_data === 128'hfcac161bee28c3c4c193f54b8233ea63)
			  $display("PASS");
		 else
			  $display("FAIL");
	end
endmodule 