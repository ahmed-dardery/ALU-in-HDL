module priority32(input logic[31:0] x, output logic[4:0] pos, output logic Z);
	logic Z3,Z2,Z1,Z0;
	logic[2:0] padding;
	logic[2:0] pos3, pos2, pos1, pos0;
	
	priority8 p3(x[31:24], pos3, Z3);
	priority8 p2(x[23:16], pos2, Z2);
	priority8 p1(x[15: 8], pos1, Z1);
	priority8 p0(x[ 7: 0], pos0, Z0);
	
	
	assign padding = Z3?(Z2?(Z1?(Z0?2'bxx:2'b11):2'b10):2'b01):2'b00;
	assign pos = {padding, Z3?(Z2?(Z1?pos0:pos1):pos2):pos3};
	assign Z = Z3 & Z2 & Z1 & Z0;
endmodule

module priority8(input logic[7:0] x, output logic[2:0] pos, output logic Z);
	always_comb begin
		Z = 0;
		casez(x)
			'b1???????: pos = 'd0;
			'b01??????: pos = 'd1;
			'b001?????: pos = 'd2;
			'b0001????: pos = 'd3;
			'b00001???: pos = 'd4;
			'b000001??: pos = 'd5;
			'b0000001?: pos = 'd6;
			'b00000001: pos = 'd7;
			default: begin
				pos = 3'bxx; Z = 1;
			end
		endcase
	end
endmodule