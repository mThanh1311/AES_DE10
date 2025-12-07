`timescale 1ns/1ps

module AddRoundKeys_tb;

    reg  [127:0] state_in;
    reg  [127:0] roundkey;
    wire [127:0] state_out;

    reg  [127:0] expected;

    AddRoundKeys dut (
        .iState(state_in),
        .iRoundKey(roundkey),
        .oState(state_out)
    );

    initial begin
        $display("===== AddRoundKeys TEST START =====");

        //---------------------------------------------------------
        // Test ROUND 1
        //---------------------------------------------------------
        state_in = $random;
        state_in = {state_in, $random};

        roundkey = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;

        expected = state_in ^ roundkey;

        #1;

        $display("\n[Round 1]");
        $display("State_in  = %h", state_in);
        $display("RoundKey  = %h", roundkey);
        $display("DUT Out   = %h", state_out);
        $display("Expected  = %h", expected);

        if (state_out !== expected)
            $display(" ---> FAIL");
        else
            $display(" ---> PASS");


        //---------------------------------------------------------
        // Test ROUND 5
        //---------------------------------------------------------
        state_in = $random;
        state_in = {state_in, $random}; // random 128-bit

        roundkey = 128'h3caaa3e8a99f9deb50f3af57adf622aa;

        expected = state_in ^ roundkey;

        #1;

        $display("\n[Round 5]");
        $display("State_in  = %h", state_in);
        $display("RoundKey  = %h", roundkey);
        $display("DUT Out   = %h", state_out);
        $display("Expected  = %h", expected);

        if (state_out !== expected)
            $display(" ---> FAIL");
        else
            $display(" ---> PASS");


        $display("\n===== AddRoundKeys TEST END =====");
        $finish;
    end	
endmodule 