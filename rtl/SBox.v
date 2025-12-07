module SBox (
	input [7:0] iData,
	output reg [7:0] oData
);

	always @ (*) begin
		case(iData)
		  8'h00: oData = 8'h63; 8'h01: oData = 8'h7c; 8'h02: oData = 8'h77; 8'h03: oData = 8'h7b;
        8'h04: oData = 8'hf2; 8'h05: oData = 8'h6b; 8'h06: oData = 8'h6f; 8'h07: oData = 8'hc5;
        8'h08: oData = 8'h30; 8'h09: oData = 8'h01; 8'h0a: oData = 8'h67; 8'h0b: oData = 8'h2b;
        8'h0c: oData = 8'hfe; 8'h0d: oData = 8'hd7; 8'h0e: oData = 8'hab; 8'h0f: oData = 8'h76;

        8'h10: oData = 8'hca; 8'h11: oData = 8'h82; 8'h12: oData = 8'hc9; 8'h13: oData = 8'h7d;
        8'h14: oData = 8'hfa; 8'h15: oData = 8'h59; 8'h16: oData = 8'h47; 8'h17: oData = 8'hf0;
        8'h18: oData = 8'had; 8'h19: oData = 8'hd4; 8'h1a: oData = 8'ha2; 8'h1b: oData = 8'haf;
        8'h1c: oData = 8'h9c; 8'h1d: oData = 8'ha4; 8'h1e: oData = 8'h72; 8'h1f: oData = 8'hc0;

        8'h20: oData = 8'hb7; 8'h21: oData = 8'hfd; 8'h22: oData = 8'h93; 8'h23: oData = 8'h26;
        8'h24: oData = 8'h36; 8'h25: oData = 8'h3f; 8'h26: oData = 8'hf7; 8'h27: oData = 8'hcc;
        8'h28: oData = 8'h34; 8'h29: oData = 8'ha5; 8'h2a: oData = 8'he5; 8'h2b: oData = 8'hf1;
        8'h2c: oData = 8'h71; 8'h2d: oData = 8'hd8; 8'h2e: oData = 8'h31; 8'h2f: oData = 8'h15;

        8'h30: oData = 8'h04; 8'h31: oData = 8'hc7; 8'h32: oData = 8'h23; 8'h33: oData = 8'hc3;
        8'h34: oData = 8'h18; 8'h35: oData = 8'h96; 8'h36: oData = 8'h05; 8'h37: oData = 8'h9a;
        8'h38: oData = 8'h07; 8'h39: oData = 8'h12; 8'h3a: oData = 8'h80; 8'h3b: oData = 8'he2;
        8'h3c: oData = 8'heb; 8'h3d: oData = 8'h27; 8'h3e: oData = 8'hb2; 8'h3f: oData = 8'h75;

        8'h40: oData = 8'h09; 8'h41: oData = 8'h83; 8'h42: oData = 8'h2c; 8'h43: oData = 8'h1a;
        8'h44: oData = 8'h1b; 8'h45: oData = 8'h6e; 8'h46: oData = 8'h5a; 8'h47: oData = 8'ha0;
        8'h48: oData = 8'h52; 8'h49: oData = 8'h3b; 8'h4a: oData = 8'hd6; 8'h4b: oData = 8'hb3;
        8'h4c: oData = 8'h29; 8'h4d: oData = 8'he3; 8'h4e: oData = 8'h2f; 8'h4f: oData = 8'h84;

        8'h50: oData = 8'h53; 8'h51: oData = 8'hd1; 8'h52: oData = 8'h00; 8'h53: oData = 8'hed;
        8'h54: oData = 8'h20; 8'h55: oData = 8'hfc; 8'h56: oData = 8'hb1; 8'h57: oData = 8'h5b;
        8'h58: oData = 8'h6a; 8'h59: oData = 8'hcb; 8'h5a: oData = 8'hbe; 8'h5b: oData = 8'h39;
        8'h5c: oData = 8'h4a; 8'h5d: oData = 8'h4c; 8'h5e: oData = 8'h58; 8'h5f: oData = 8'hcf;

        8'h60: oData = 8'hd0; 8'h61: oData = 8'hef; 8'h62: oData = 8'haa; 8'h63: oData = 8'hfb;
        8'h64: oData = 8'h43; 8'h65: oData = 8'h4d; 8'h66: oData = 8'h33; 8'h67: oData = 8'h85;
        8'h68: oData = 8'h45; 8'h69: oData = 8'hf9; 8'h6a: oData = 8'h02; 8'h6b: oData = 8'h7f;
        8'h6c: oData = 8'h50; 8'h6d: oData = 8'h3c; 8'h6e: oData = 8'h9f; 8'h6f: oData = 8'ha8;

        8'h70: oData = 8'h51; 8'h71: oData = 8'ha3; 8'h72: oData = 8'h40; 8'h73: oData = 8'h8f;
        8'h74: oData = 8'h92; 8'h75: oData = 8'h9d; 8'h76: oData = 8'h38; 8'h77: oData = 8'hf5;
        8'h78: oData = 8'hbc; 8'h79: oData = 8'hb6; 8'h7a: oData = 8'hda; 8'h7b: oData = 8'h21;
        8'h7c: oData = 8'h10; 8'h7d: oData = 8'hff; 8'h7e: oData = 8'hf3; 8'h7f: oData = 8'hd2;

        8'h80: oData = 8'hcd; 8'h81: oData = 8'h0c; 8'h82: oData = 8'h13; 8'h83: oData = 8'hec;
        8'h84: oData = 8'h5f; 8'h85: oData = 8'h97; 8'h86: oData = 8'h44; 8'h87: oData = 8'h17;
        8'h88: oData = 8'hc4; 8'h89: oData = 8'ha7; 8'h8a: oData = 8'h7e; 8'h8b: oData = 8'h3d;
        8'h8c: oData = 8'h64; 8'h8d: oData = 8'h5d; 8'h8e: oData = 8'h19; 8'h8f: oData = 8'h73;

        8'h90: oData = 8'h60; 8'h91: oData = 8'h81; 8'h92: oData = 8'h4f; 8'h93: oData = 8'hdc;
        8'h94: oData = 8'h22; 8'h95: oData = 8'h2a; 8'h96: oData = 8'h90; 8'h97: oData = 8'h88;
        8'h98: oData = 8'h46; 8'h99: oData = 8'hee; 8'h9a: oData = 8'hb8; 8'h9b: oData = 8'h14;
        8'h9c: oData = 8'hde; 8'h9d: oData = 8'h5e; 8'h9e: oData = 8'h0b; 8'h9f: oData = 8'hdb;

        8'ha0: oData = 8'he0; 8'ha1: oData = 8'h32; 8'ha2: oData = 8'h3a; 8'ha3: oData = 8'h0a;
        8'ha4: oData = 8'h49; 8'ha5: oData = 8'h06; 8'ha6: oData = 8'h24; 8'ha7: oData = 8'h5c;
        8'ha8: oData = 8'hc2; 8'ha9: oData = 8'hd3; 8'haa: oData = 8'hac; 8'hab: oData = 8'h62;
        8'hac: oData = 8'h91; 8'had: oData = 8'h95; 8'hae: oData = 8'he4; 8'haf: oData = 8'h79;

        8'hb0: oData = 8'he7; 8'hb1: oData = 8'hc8; 8'hb2: oData = 8'h37; 8'hb3: oData = 8'h6d;
        8'hb4: oData = 8'h8d; 8'hb5: oData = 8'hd5; 8'hb6: oData = 8'h4e; 8'hb7: oData = 8'ha9;
        8'hb8: oData = 8'h6c; 8'hb9: oData = 8'h56; 8'hba: oData = 8'hf4; 8'hbb: oData = 8'hea;
        8'hbc: oData = 8'h65; 8'hbd: oData = 8'h7a; 8'hbe: oData = 8'hae; 8'hbf: oData = 8'h08;

        8'hc0: oData = 8'hba; 8'hc1: oData = 8'h78; 8'hc2: oData = 8'h25; 8'hc3: oData = 8'h2e;
        8'hc4: oData = 8'h1c; 8'hc5: oData = 8'ha6; 8'hc6: oData = 8'hb4; 8'hc7: oData = 8'hc6;
        8'hc8: oData = 8'he8; 8'hc9: oData = 8'hdd; 8'hca: oData = 8'h74; 8'hcb: oData = 8'h1f;
        8'hcc: oData = 8'h4b; 8'hcd: oData = 8'hbd; 8'hce: oData = 8'h8b; 8'hcf: oData = 8'h8a;

        8'hd0: oData = 8'h70; 8'hd1: oData = 8'h3e; 8'hd2: oData = 8'hb5; 8'hd3: oData = 8'h66;
        8'hd4: oData = 8'h48; 8'hd5: oData = 8'h03; 8'hd6: oData = 8'hf6; 8'hd7: oData = 8'h0e;
        8'hd8: oData = 8'h61; 8'hd9: oData = 8'h35; 8'hda: oData = 8'h57; 8'hdb: oData = 8'hb9;
        8'hdc: oData = 8'h86; 8'hdd: oData = 8'hc1; 8'hde: oData = 8'h1d; 8'hdf: oData = 8'h9e;

        8'he0: oData = 8'he1; 8'he1: oData = 8'hf8; 8'he2: oData = 8'h98; 8'he3: oData = 8'h11;
        8'he4: oData = 8'h69; 8'he5: oData = 8'hd9; 8'he6: oData = 8'h8e; 8'he7: oData = 8'h94;
        8'he8: oData = 8'h9b; 8'he9: oData = 8'h1e; 8'hea: oData = 8'h87; 8'heb: oData = 8'he9;
        8'hec: oData = 8'hce; 8'hed: oData = 8'h55; 8'hee: oData = 8'h28; 8'hef: oData = 8'hdf;

        8'hf0: oData = 8'h8c; 8'hf1: oData = 8'ha1; 8'hf2: oData = 8'h89; 8'hf3: oData = 8'h0d;
        8'hf4: oData = 8'hbf; 8'hf5: oData = 8'he6; 8'hf6: oData = 8'h42; 8'hf7: oData = 8'h68;
        8'hf8: oData = 8'h41; 8'hf9: oData = 8'h99; 8'hfa: oData = 8'h2d; 8'hfb: oData = 8'h0f;
        8'hfc: oData = 8'hb0; 8'hfd: oData = 8'h54; 8'hfe: oData = 8'hbb; 8'hff: oData = 8'h16;

        default: oData = 8'h00;
		endcase
	end

endmodule 