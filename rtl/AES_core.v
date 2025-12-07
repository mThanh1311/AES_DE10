module AES_core(
    input  wire         iClk,
    input  wire         iRst,
    input  wire         iStart,

    input  wire [127:0] iPlaintext,
    input  wire [127:0] iKey,

    output reg  [127:0] oCiphertext,
    output reg          oDone
);

    //---------------------------------------------------------
    // FSM State Encoding (replacing typedef enum)
    //---------------------------------------------------------
    localparam S_IDLE  = 4'd0;
    localparam S_ADD0  = 4'd1;
    localparam S_ROUND = 4'd2;
    localparam S_FINAL = 4'd3;
    localparam S_DONE  = 4'd4;

    reg [3:0] state;
    reg [3:0] next_state;

    //---------------------------------------------------------
    // AES internal signals
    //---------------------------------------------------------
    reg  [127:0] state_reg;   // internal AES state
    wire [127:0] round_out;

    reg  [3:0] round;         // round counter: 0 → 10

    // Round keys (Verilog version of array)
    wire [127:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;

    //---------------------------------------------------------
    // KeyExpansion Core
    //---------------------------------------------------------
		wire [1407:0] roundkeys;

		KeyExpansion keyexp (
			 .iKey(iKey),
			 .oRoundKeys(roundkeys)
		);

		// Split into w0..w10
		wire [127:0] w [0:10];

		assign w[0]  = roundkeys[ 127:   0];
		assign w[1]  = roundkeys[ 255: 128];
		assign w[2]  = roundkeys[ 383: 256];
		assign w[3]  = roundkeys[ 511: 384];
		assign w[4]  = roundkeys[ 639: 512];
		assign w[5]  = roundkeys[ 767: 640];
		assign w[6]  = roundkeys[ 895: 768];
		assign w[7]  = roundkeys[1023: 896];
		assign w[8]  = roundkeys[1151:1024];
		assign w[9]  = roundkeys[1279:1152];
		assign w[10] = roundkeys[1407:1280];
    //---------------------------------------------------------
    // AES Round Block
    //---------------------------------------------------------
    wire [127:0] round_key = 
        (round == 4'd0)  ? w0  :
        (round == 4'd1)  ? w1  :
        (round == 4'd2)  ? w2  :
        (round == 4'd3)  ? w3  :
        (round == 4'd4)  ? w4  :
        (round == 4'd5)  ? w5  :
        (round == 4'd6)  ? w6  :
        (round == 4'd7)  ? w7  :
        (round == 4'd8)  ? w8  :
        (round == 4'd9)  ? w9  : w10 ;

    AES_Round u_round (
        .iState(state_reg),
        .iRoundKey(round_key),
        .iFinalRound(round == 4'd10),
        .oState(round_out)
    );

    //---------------------------------------------------------
    // FSM Sequential Logic
    //---------------------------------------------------------
    always @(posedge iClk or posedge iRst) begin
        if (iRst) begin
            state       <= S_IDLE;
            round       <= 4'd0;
            state_reg   <= 128'd0;
            oCiphertext <= 128'd0;
            oDone       <= 1'b0;
        end 
        else begin
            state <= next_state;

            case (state)
                S_IDLE:
                    if (iStart) begin
                        round       <= 4'd0;
                        oDone       <= 1'b0;
                        state_reg   <= 128'd0;
                    end

                S_ADD0:
                    state_reg <= iPlaintext ^ w0;

                S_ROUND:
                    if (round < 4'd10) begin
                        state_reg <= round_out;
                        round <= round + 1'b1;
                    end

                S_FINAL:
                    state_reg <= round_out;

						  
                S_DONE:
						begin 
                    oCiphertext <= state_reg;
                    oDone <= 1'b1;
						end

            endcase
        end
    end

    //---------------------------------------------------------
    // FSM Next State Logic (Combinational)
    //---------------------------------------------------------
    always @(*) begin
        case(state)

            S_IDLE:
                next_state = (iStart ? S_ADD0 : S_IDLE);

            S_ADD0:
                next_state = S_ROUND;

            S_ROUND:
                next_state = (round == 4'd10) ? S_FINAL : S_ROUND;

            S_FINAL:
                next_state = S_DONE;

            S_DONE:
                next_state = S_IDLE;

            default:
                next_state = S_IDLE;

        endcase
    end

endmodule