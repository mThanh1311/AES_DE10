`timescale 1ns/1ps
module MixColumns_tb;

    reg  [127:0] in_state;
    wire [127:0] out_state;

    // Instantiate DUT
    MixColumns dut (
        .iData(in_state),
        .oData(out_state)
    );

    initial begin
        $display("===== MIXCOLUMNS TEST START =====");

        // Test vector: 00 01 02 ... 0F
        in_state = 128'h8233ea63fcac161bee28c3c4c193f54b;

        #10; // allow logic to settle

        $display("Input  = %032h", in_state);
        $display("Output = %032h", out_state);
		  

		 if (out_state === 128'hc3a2db82019e5193b8240c5189b37ea8)
			  $display("PASS");
		 else
			  $display("FAIL");

        $display("===== MIXCOLUMNS TEST END =====");
        $finish;
    end

endmodule
