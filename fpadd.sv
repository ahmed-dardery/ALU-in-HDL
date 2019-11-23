//calculates A + B in IEEE floating point format.
//Format: 1 bit sign + 8 bits exp + 23 bits mantissa
module fpadd(input logic [31:0] A,B,
				output logic [31:0] S);
				
	logic [7:0] exp_A, exp_B, exp_initial, exp_S, shift;
	
	//three extra bits : implicit one and room for two's complement
	logic [25:0] mant_A, mant_B, mant_shifted;
	//implicit one only
	logic [23:0] mant_S;
	
	logic A_less_B, neg_A, neg_B, neg_shifted, neg_S;
	
	assign {neg_A, neg_B} = {A[31], B[31]};
	assign {exp_A, exp_B} = {A[30:23], B[30:23]};
	

	expcomp expcomp1(exp_A, exp_B, A_less_B, exp_initial, shift);
	shiftmant shiftmant1(A_less_B, mant_A, mant_B, shift, mant_shifted);
	sign sign1(A_less_B, neg_A, neg_B, neg_shifted);
	mantissa mantissa1(A, B, mant_A, mant_B);
	
	addmant addmant1(
		A_less_B, 
		neg_A, neg_B, neg_shifted,
		exp_initial,
		mant_A, mant_B, mant_shifted,
		mant_S, exp_S, neg_S);
		
	normalization normalization1(neg_S, exp_S, mant_S, S);
endmodule

module sign(input logic A_less_B, neg_A, neg_B, output logic neg_shifted);
	assign neg_shifted = A_less_B ? neg_A : neg_B;
endmodule

module mantissa(input logic[31:0] A, B,
				output logic[25:0] mant_A, mant_B);

	logic [2:0] implicit_A, implicit_B;
	
	assign implicit_A = {2'b00, |A};		//001 if nonzero, 000 if zero
	assign implicit_B = {2'b00, |B};		//001 if nonzero, 000 if zero
	
	assign mant_A = {implicit_A, A[22:0]};
	assign mant_B = {implicit_B, B[22:0]};
	
endmodule

//checks which of A and B' exponents is bigger
//returns exponent of bigger and the difference (shift) between the two
module expcomp(input logic[7:0] exp_A, exp_B,
				output logic A_less_B,
				output logic[7:0] exp_S, shift);
	
	logic[7:0] A_minus_B, B_minus_A;
	assign A_minus_B = exp_A - exp_B;
	assign B_minus_A = exp_B - exp_A;
	assign A_less_B = A_minus_B[7];
	
	always_comb
		if (A_less_B) begin
			exp_S = exp_B;
			shift = B_minus_A;
		end
		else begin
			exp_S = exp_A;
			shift = A_minus_B;
		end
endmodule

//shifts the smaller from a and b so that they have the same exponent (as the bigger of them)
module shiftmant(input logic A_less_B,
					input logic [25:0] mant_A, mant_B,
					input logic [7:0] shift,
					output logic [25:0] mant_shifted);

	assign mant_shifted = A_less_B ? (mant_A >> shift): (mant_B >> shift);
	
endmodule

module addmant(input logic A_less_B,
				neg_A, neg_B, neg_shifted,
				input logic[7:0] exp_initial,
                input logic[25:0] mant_A, mant_B, mant_shifted,
                output logic[23:0] mant_S,
                output logic[7:0] exp_S,
				output logic neg_S);
	
	logic neg_original;	
    logic[25:0] sum, result;
    logic[25:0] original;
	
    assign original = A_less_B ? mant_B : mant_A;
	assign neg_original = A_less_B ? neg_B : neg_A;
	
    assign sum =
				(neg_shifted ? -mant_shifted : mant_shifted) +
				(neg_original ? -original : original);

	//2's complement mantissa
	assign neg_S = sum[25];
	assign result = sum[25]? -sum : sum;
	
	//extra bit case for addition
    assign mant_S = result[24] ? result[24:1] : result[23:0];
    assign exp_S = result[24] ? (exp_initial + 1) : exp_initial;
    
endmodule

module normalization(input logic neg_S, input logic[7:0] exp_S, input logic[23:0] mant_S,
					output logic[31:0] S);

	logic Z;
	logic[4:0] shift;
	logic[7:0] newexp_S;
	logic[22:0] newmant_S;
	logic[31:0] tempmant, shifted_tempmant;
	
	assign tempmant = mant_S << 8;
	
	priority32 pri(tempmant, shift, Z);
	
	assign newexp_S = exp_S - shift;
	assign shifted_tempmant = tempmant << shift;
	assign newmant_S = shifted_tempmant[30:8];
	assign S = Z ? 0 : {neg_S, newexp_S, newmant_S};
endmodule