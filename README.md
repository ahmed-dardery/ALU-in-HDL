# ALU-in-HDL
ALU assignment for Computer Architecture course.

# Task1
  Design and build an ALU in Verilog that receives a 4 bits selection code to decide which operation to perform. Use the abstractions available in SystemVerilog and Quartus if helpful and design a module for any function that does not have abstraction.
  
  ALU should do the following operations:
    Integer Math Operations. Add, Subtract, Multiply, Integer Division, Shift Operations. Logical Shift Left, Logical Shift Right, Mathematical Shift Right, Rotate Right, Logical Operations. AND, OR, XOR, INVERT (The first input)
  
  ALU has 6 flags Negative, Zero, Carry, oVerflow, Equal and Less than (a < b)
## Requirements
  1. Design and Develop the circuit in Verilog.
  2. Use the simulation tool to simulate the circuit and ensure it works well.
  3. Deliver Verilog code, schematic design and simulation results.

## Submissions:
  1. implemented using the operators available in SystemVerilog.
  2. TBD
  3. The design is in the ALU.sv file. Schematic and simulation results are TBD.

# Task2
You are given a schematic and Verilog design for a floating-point adder.
##Requirements
  1. Ensure the given code works and compiles correctly.
  2. Use better naming and improve coding style.
  3. Extend the circuit design to handle the cases of
      1. Adding positive and negative numbers. (note that mantissa is NOT in two's complement format)
      2. Adding to +inf or -inf
      3. Adding to NaN
      4. Adding a num + Zero
      5. If addition result is Zero.
  4. Develop extended circuit design, Verilog & simulation.

## Submissions
  1. moot point, the code was rewritten.
  2. see (1)
  3. As a bonus, normalization was implemented using a priority32 consisting of four priority8 modules.
     1. implemented using sign bit passing to the addmant function
     2. implemented using a special handler
     3. see (ii)
     4. implemented automatically using implicit one handling
     5. see (iv)
  4. The design is fpadd.sv and uses priority32.sv, the testbench is fpadd_testbench.sv with everything test-related in 'testcases' directory. The simulation is TBD.
