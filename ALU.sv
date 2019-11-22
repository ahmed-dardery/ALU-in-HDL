//Negative, Zero, Carry, oVerflow, Equal, Less than
module ALU(input logic[15:0] a,b, input logic[3:0] selection, output logic[15:0] y, output logic N,Z,C,V,E,L);
 
typedef enum logic[3:0] {ADD, SUBTRACT, MULTIPLY, DIVISION, MODULUS, LOGIC_LEFT, LOGIC_RIGHT, MATH_LEFT, MATH_RIGHT, ROTATE_RIGHT, ROTATE_LEFT, AND, OR, XOR, INVERT}  operators;
 
logic[3:0] shortb;
logic[34:0] realAns;
assign shortb = b[3:0];
always_comb begin
    case(selection)
        ADD:
            realAns = a + b;
        SUBTRACT:
            realAns = a - b;
        MULTIPLY:
            realAns = a * b;
        DIVISION:
            realAns = a / b;
        MODULUS:
            realAns = a % b;
        LOGIC_LEFT:
            realAns = a << shortb;
        LOGIC_RIGHT:
            realAns = a >> shortb;
        MATH_LEFT:
            realAns = a <<< shortb;
        MATH_RIGHT:
            realAns = a >>> shortb;
        ROTATE_RIGHT:
            realAns = (a << shortb) | (a >> (~shortb+1));
        ROTATE_LEFT:
            realAns = (a >> shortb) | (a << (~shortb+1));
        AND:
            realAns = a & b;
        OR:
            realAns = a | b;
        XOR:
            realAns = a ^ b;
        INVERT:
            realAns = ~a;
        default:
            realAns = a;
    endcase
    end
	
	//Negative, Zero, Carry, oVerflow, Equal, Less than
	assign y = realAns[15:0];
		
	assign N = y[15];	//two's complement
	assign Z = (realAns == 0); // because maybe answer = 10000000000000000 so c will not see the last 1
	assign C = realAns[16];
	assign V = (realAns != y);
	assign E = (a == b);
	assign L = (a < b);
endmodule
