//ieee754add.fpadd_testbench
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
				$display("Error in test %d: inputs = %b + %b", vectornum + 1, a, b);
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