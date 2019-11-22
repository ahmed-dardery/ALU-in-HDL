module fpadd_testbench();
	logic clk, reset;
	logic [31:0] a, b, s, sexpected;
	logic [31:0] vectornum, errors;
	logic [95:0] testvectors[10000:0];
	
	// instantiate device under test
	fpadd dut(a, b, s);
	
	// generate clock
	always begin
		clk = 1; #5; clk = 0; #5;
	end
	// at start of test, load vectors
	// and pulse reset
	initial begin
		$readmemb("D:\\testvector.tv", testvectors);
		vectornum = 0; errors = 0;
		reset = 1; #100; reset = 0;
	end
	// apply test vectors on rising edge of clk
	always @(posedge clk) begin
		#1; {a, b, sexpected} = testvectors[vectornum];
	end
	
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset
			if (s !== sexpected) begin // check result
				$display("Error: inputs = %b + %b", a, b);
				$display(" outputs = %b (%b expected)", s, sexpected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				//$finish;
				reset = 1;
			end
		end
endmodule

//calculates A + B in IEEE floating point format.
//Format: 1 bit sign + 8 bits exp + 23 bits mantissa
module fpadd(input logic [31:0] A,B,
				output logic [31:0] S);
				
	logic [7:0] exp_A, exp_B, exp_initial, exp_S, shift;
	
	//three extra bits : implicit one and room for two's complement
	logic [25:0] mant_A, mant_B, mant_shifted;
	logic [22:0] mant_S;
	logic A_less_B, neg_A, neg_B, neg_shifted, neg_S;
	
	assign {neg_A, neg_B} = {A[31], B[31]};
	assign {exp_A, exp_B} = {A[30:23], B[30:23]};
	
	//sign bit + exponent + result mantissa
	assign S = {neg_S, exp_S, mant_S};

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
endmodule

module sign(input logic A_less_B, neg_A, neg_B, output logic neg_shifted);
	assign neg_shifted = A_less_B ? neg_B : neg_A;
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
                output logic[22:0] mant_S,
                output logic[7:0] exp_S,
				output logic neg_S);
	
	logic neg_original;	
    logic[25:0] sum, result;
    logic[25:0] orginal;
	
    assign orginal = A_less_B ? mant_B : mant_A;
	assign neg_original = A_less_B ? neg_B : neg_A;
	
    assign sum =
				(neg_shifted ? -mant_shifted : mant_shifted) +
				(neg_original ? -orginal : original);

	//2's complement mantissa
	assign neg_S = sum[25];
	assign result = sum[25]? -sum : sum;
	
	//normalization
    assign mant_S = result[24] ? result[23:1] : result[22:0];
    assign exp_S = result[24] ? (exp_initial + 1) : exp_initial;
    
endmodule