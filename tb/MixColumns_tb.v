module MixColumns_tb;
	reg [127:0] in_data;
	wire [127:0] out_data;
	
	MixColumns u_mixcolumns(
			.iData(in_data),
			.oData(out_data)
	);
	integer k;
	initial begin
	
		 $display("===== TEST MixColumns =====");

		 in_data    = 128'hfcac161bee28c3c4c193f54b8233ea63;

		 #10;
	
			$display("BYTE DUMP:");
			for ( k=0; k<16; k=k+1)
				 $display("[%0d] = %02h", k, in_data[8*k +: 8]);
 

		 $display("DUT     = 128'h%h", out_data);
		 $display("Golden  = 128'h48f83740a2097ac975840a7f6c829841");

		 if (out_data === 128'h48f83740a2097ac975840a7f6c829841)
			  $display("PASS");
		 else
			  $display("FAIL");
	end
endmodule 