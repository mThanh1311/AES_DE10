module AESCore #(
    parameter KEY_SIZE = 128   // 128 / 192 / 256
)(
    input  wire                 iClk,
    input  wire                 iRst,
    input  wire                 iStart,

    input  wire [127:0]         iPlaintext,
    input  wire [KEY_SIZE-1:0] iKey,

    output reg  [127:0]         oCiphertext,
    output reg                  oDone
);

    // =================================================
    // Derived AES parameters
    // =================================================
    localparam integer Nr =
        (KEY_SIZE == 128) ? 10 :
        (KEY_SIZE == 192) ? 12 :
        (KEY_SIZE == 256) ? 14 : 10;

    // =================================================
    // FSM states
    // =================================================
    localparam S_IDLE  = 3'd0;
    localparam S_INIT  = 3'd1;   // Round 0
    localparam S_ROUND = 3'd2;   // Round 1 → Nr-1
    localparam S_FINAL = 3'd3;   // Round Nr
    localparam S_DONE  = 3'd4;

    reg [2:0] state, next_state;

    // =================================================
    // Round counter
    // =================================================
    reg [3:0] round;   // max 14

    // =================================================
    // AES state register
    // =================================================
    reg  [127:0] state_reg;
    wire [127:0] round_out;

    // =================================================
    // KeyExpansion
    // =================================================
    wire [128*(Nr+1)-1:0] roundkeys;
    wire [127:0] w [0:Nr];

    KeyExpansion #(
        .KEY_SIZE(KEY_SIZE)
    ) u_keyexp (
        .iKey(iKey),
        .oRoundKeys(roundkeys)
    );

    genvar i;
    generate
        for (i = 0; i <= Nr; i = i + 1) begin : SPLIT_KEYS
            // MSB = round key 0
            assign w[i] = roundkeys[128*(Nr-i+1)-1 -: 128];
        end
    endgenerate

    // =================================================
    // ---------- INLINE AES ROUND DATAPATH ----------
    // =================================================
    wire [127:0] sb_out;
    wire [127:0] sr_out;
    wire [127:0] mc_out;
    wire [127:0] round_data;

    // SubBytes
    SubBytes u_subbytes (
        .iData(state_reg),
        .oData(sb_out)
    );

    // ShiftRows
    ShiftRows u_shiftrows (
        .iData(sb_out),
        .oData(sr_out)
    );

    // MixColumns
    MixColumns u_mixcolumns (
        .iData(sr_out),
        .oData(mc_out)
    );

    // Final round bypass MixColumns
    assign round_data = (round == Nr) ? sr_out : mc_out;

    // AddRoundKey
    assign round_out = round_data ^ w[round];

    // =================================================
    // FSM sequential logic
    // =================================================
    always @(posedge iClk or posedge iRst) begin
        if (iRst) begin
            state       <= S_IDLE;
            round       <= 4'd0;
            state_reg   <= 128'd0;
            oCiphertext <= 128'd0;
            oDone       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)

                // -----------------------------------------
                S_IDLE: begin
                    oDone <= 1'b0;
                    if (iStart) begin
                        state_reg <= iPlaintext;
                        round     <= 4'd0;
                    end
                end

                // -----------------------------------------
                // Round 0: AddRoundKey only
                S_INIT: begin
                    state_reg <= state_reg ^ w[0];
                    round     <= 4'd1;
                end

                // -----------------------------------------
                // Round 1 → Nr-1
                S_ROUND: begin
                    state_reg <= round_out;
                    round     <= round + 1'b1;
                end

                // -----------------------------------------
                // Final round (round == Nr)
                S_FINAL: begin
                    state_reg <= round_out;
                end

                // -----------------------------------------
                S_DONE: begin
                    oCiphertext <= state_reg;
                    oDone       <= 1'b1;
                end

            endcase
        end
    end

    // =================================================
    // FSM next-state logic
    // =================================================
    always @(*) begin
        case (state)

            S_IDLE:
                next_state = iStart ? S_INIT : S_IDLE;

            S_INIT:
                next_state = S_ROUND;

            S_ROUND:
                next_state = (round == Nr-1) ? S_FINAL : S_ROUND;

            S_FINAL:
                next_state = S_DONE;

            S_DONE:
                next_state = S_IDLE;

            default:
                next_state = S_IDLE;

        endcase
    end

endmodule 