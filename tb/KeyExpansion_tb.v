`timescale 1ns/1ps
module KeyExpansion_tb;

    // =================================================
    // AES-128
    // =================================================
    reg  [127:0] key128;
    wire [1407:0] rk128;   // 11 × 128

    KeyExpansion #(.KEY_SIZE(128)) dut128 (
        .iKey(key128),
        .oRoundKeys(rk128)
    );

    reg [127:0] golden128 [0:10];

    // =================================================
    // AES-192
    // =================================================
    reg  [191:0] key192;
    wire [1663:0] rk192;   // 13 × 128

    KeyExpansion #(.KEY_SIZE(192)) dut192 (
        .iKey(key192),
        .oRoundKeys(rk192)
    );

    reg [127:0] golden192 [0:12];

    // =================================================
    // AES-256
    // =================================================
    reg  [255:0] key256;
    wire [1919:0] rk256;   // 15 × 128

    KeyExpansion #(.KEY_SIZE(256)) dut256 (
        .iKey(key256),
        .oRoundKeys(rk256)
    );

    reg [127:0] golden256 [0:14];

    integer i;
    reg [127:0] rk;

    initial begin
        #1;
        $display("\n========== KEY EXPANSION TEST START ==========\n");

        // =================================================
        // AES-128
        // =================================================
        key128 = 128'h000102030405060708090A0B0C0D0E0F;

        golden128[0]  = 128'h000102030405060708090a0b0c0d0e0f;
        golden128[1]  = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
        golden128[2]  = 128'hb692cf0b643dbdf1be9bc5006830b3fe;
        golden128[3]  = 128'hb6ff744ed2c2c9bf6c590cbf0469bf41;
        golden128[4]  = 128'h47f7f7bc95353e03f96c32bcfd058dfd;
        golden128[5]  = 128'h3caaa3e8a99f9deb50f3af57adf622aa;
        golden128[6]  = 128'h5e390f7df7a69296a7553dc10aa31f6b;
        golden128[7]  = 128'h14f9701ae35fe28c440adf4d4ea9c026;
        golden128[8]  = 128'h47438735a41c65b9e016baf4aebf7ad2;
        golden128[9]  = 128'h549932d1f08557681093ed9cbe2c974e;
        golden128[10] = 128'h13111d7fe3944a17f307a78b4d2b30c5;

        #5;
        $display("---- AES-128 ----");
        for (i = 0; i <= 10; i = i + 1) begin
            rk = rk128[(1407 - 128*i) -: 128];
            $display("RK%-2d DUT=%h  GOLDEN=%h %s",
                     i, rk, golden128[i],
                     (rk===golden128[i])?"PASS":"FAIL");
        end

        // =================================================
        // AES-192
        // =================================================
        key192 = 192'h000102030405060708090A0B0C0D0E0F1011121314151617;

        golden192[0]  = 128'h000102030405060708090a0b0c0d0e0f;
        golden192[1]  = 128'h10111213141516175846f2f95c43f4fe;
        golden192[2]  = 128'h544afef55847f0fa4856e2e95c43f4fe;
        golden192[3]  = 128'h40f949b31cbabd4d48f043b810b7b342;
        golden192[4]  = 128'h58e151ab04a2a5557effb5416245080c;
        golden192[5]  = 128'h2ab54bb43a02f8f662e3a95d66410c08;
        golden192[6]  = 128'hf501857297448d7ebdf1c6ca87f33e3c;
        golden192[7]  = 128'he510976183519b6934157c9ea351f1e0;
        golden192[8]  = 128'h1ea0372a995309167c439e77ff12051e;
        golden192[9]  = 128'hdd7e0e887e2fff68608fc842f9dcc154;
        golden192[10] = 128'h859f5f237a8d5a3dc0c02952beefd63a;
        golden192[11] = 128'hde601e7827bcdf2ca223800fd8aeda32;
        golden192[12] = 128'ha4970a331a78dc09c418c271e3a41d5d;

        #5;
        $display("\n---- AES-192 ----");
        for (i = 0; i <= 12; i = i + 1) begin
            rk = rk192[(1663 - 128*i) -: 128];
            $display("RK%-2d DUT=%h  GOLDEN=%h %s",
                     i, rk, golden192[i],
                     (rk===golden192[i])?"PASS":"FAIL");
        end

        // =================================================
        // AES-256
        // =================================================
		  key256 = { 128'h000102030405060708090A0B0C0D0E0F,
							128'h101112131415161718191A1B1C1D1E1F
			};


        golden256[0]  = 128'h000102030405060708090a0b0c0d0e0f;
        golden256[1]  = 128'h101112131415161718191a1b1c1d1e1f;
        golden256[2]  = 128'ha573c29fa176c498a97fce93a572c09c;
        golden256[3]  = 128'h1651a8cd0244beda1a5da4c10640bade;
        golden256[4]  = 128'hae87dff00ff11b68a68ed5fb03fc1567;
        golden256[5]  = 128'h6de1f1486fa54f9275f8eb5373b8518d;
        golden256[6]  = 128'hc656827fc9a799176f294cec6cd5598b;
        golden256[7]  = 128'h3de23a75524775e727bf9eb45407cf39;
        golden256[8]  = 128'h0bdc905fc27b0948ad5245a4c1871c2f;
        golden256[9]  = 128'h45f5a66017b2d387300d4d33640a820a;
        golden256[10] = 128'h7ccff71cbeb4fe5413e6bbf0d261a7df;
        golden256[11] = 128'hf01afafee7a82979d7a5644ab3afe640;
        golden256[12] = 128'h2541fe719bf500258813bbd55a721c0a;
        golden256[13] = 128'h4e5a6699a9f24fe07e572baacdf8cdea;
        golden256[14] = 128'h24fc79ccbf0979e9371ac23c6d68de36;

        #5;
        $display("\n---- AES-256 ----");
        for (i = 0; i <= 14; i = i + 1) begin
            rk = rk256[(1919 - 128*i) -: 128];
            $display("RK%-2d DUT=%h  GOLDEN=%h %s",
                     i, rk, golden256[i],
                     (rk===golden256[i])?"PASS":"FAIL");
        end

        $display("\n========== KEY EXPANSION TEST END ==========\n");
        #10;
        $finish;
    end

endmodule