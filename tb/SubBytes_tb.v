`timescale 1ns/1ps
module SubBytes_tb;
	
	reg [127:0] in_data;
	wire [127:0] out_data;
	
	SubBytes u_subbytes (
			.iData(in_data),
			.oData(out_data)
	);
	
	initial begin
	
		 $display("===== TEST SUBBYTES =====");

		 in_data    = 128'h112233445566778899aabbccddeeff00;

		 #10;

		 $display("DUT     = %h", out_data);
		 $display("Golden  = 128'h8293c31bfc33f5c4eeacea4bc1281663");

		 if (out_data === 128'h8293c31bfc33f5c4eeacea4bc1281663)
			  $display("PASS");
		 else
			  $display("FAIL");
	end
endmodule 