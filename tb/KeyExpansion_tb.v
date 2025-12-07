`timescale 1ns/1ps
module KeyExpansion_tb;

    reg  [127:0] key;
    wire [1407:0] roundkeys;   // 11 × 128 = 1408 bits

    // DUT
    KeyExpansion dut (
        .iKey(key),
        .oRoundKeys(roundkeys)
    );

    // Reference golden keys from FIPS-197
    reg [127:0] golden [0:10];
	 reg [127:0] rk;

	 integer i;
    
    initial begin
        $display("===== KEY EXPANSION TEST START =====");

        // Input Key
        key = 128'h000102030405060708090a0b0c0d0e0f;

        // Expected round keys
        golden[0]  = 128'h000102030405060708090a0b0c0d0e0f;
        golden[1]  = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
        golden[2]  = 128'hb692cf0b643dbdf1be9bc5006830b3fe;
        golden[3]  = 128'hb6ff744ed2c2c9bf6c590cbf0469bf41;
        golden[4]  = 128'h47f7f7bc95353e03f96c32bcfd058dfd;
        golden[5]  = 128'h3caaa3e8a99f9deb50f3af57adf622aa;
        golden[6]  = 128'h5e390f7df7a69296a7553dc10aa31f6b;
        golden[7]  = 128'h14f9701ae35fe28c440adf4d4ea9c026;
        golden[8]  = 128'h47438735a41c65b9e016baf4aebf7ad2;
        golden[9]  = 128'h549932d1f08557681093ed9cbe2c974e;
        golden[10] = 128'h13111d7fe3944a17f307a78b4d2b30c5;

        #5;

        // Compare one by one
        for (i = 0; i < 11; i = i + 1) begin
            rk = roundkeys[128*i +: 128];

            $display("\nRound Key %0d:", i);
            $display(" DUT     = %h", rk);
            $display(" Golden  = %h", golden[i]);

            if (rk !== golden[i])
                $display(" ---> FAIL");
            else
                $display(" ---> PASS");
        end

        $display("\n===== KEY EXPANSION TEST END =====");
        $finish;
    end

endmodule 