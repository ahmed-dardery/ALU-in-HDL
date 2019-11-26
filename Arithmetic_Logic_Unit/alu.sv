//Negative, Zero, Carry, oVerflow, Equal, Less than
module task1(input logic[15:0] a,b, input logic[3:0] selection, output logic[15:0] y, output logic N,Z,C,V,E,L);
 
typedef enum logic[3:0] {ADD, SUBTRACT, MULTIPLY, DIVISION, MODULUS, LOGIC_LEFT, LOGIC_RIGHT, MATH_LEFT, MATH_RIGHT, ROTATE_RIGHT, ROTATE_LEFT, AND, OR, XOR, INVERT}  operators;
/*
ADD -> 0000
SUBTRACT-> 0001
MULTIPLY -> 0010
DIVISION -> 0011
MODULUS -> 0100
LOGIC_LEFT -> 0101
LOGIC_RIGHT -> 0110
MATH_LEFT -> 0111
MATH_RIGHT -> 1000
ROTATE_RIGHT -> 1001
ROTATE_LEFT -> 1010
AND -> 1011
OR -> 1100
XOR -> 1101
INVERT -> 1110
*/
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
    assign N = y[15];    //two's complement
    assign Z = (realAns == 0); // because maybe answer = 10000000000000000 so c will not see the last 1
    assign C = realAns[16];
    assign V = (!(a[15]^b[15] & selection = ADD) & ((realAns != y)|(y[15]^a[15])))|((realAns != y & selection != ADD));
    assign E = (a == b);
    assign L = ($signed(a) < $signed(b));
endmodule