module ALU (m, s1, s0, A, B, out);
    input m, s1, s0;
    input [3:0] A, B;
    output reg [3:0] out;
    
    always @ (m, s1, s0, A, B)
    begin
        if(m == 1'b0) //logic operation
            case ({s1, s0})
                2'b00: out = ~A; //bitwise negation
                2'b01: out = A & B; //bitwise AND
                2'b10: out = A ^ B; //bitwise XOR
                default: out = A | B; //bitwise OR
            endcase
        else //arithmetic operation
            case ({s1, s0})
                2'b00: out = A - 1; // decrement
                2'b01: out = A + B; //addition
                2'b10: out = A - B; //subtraction
                default: out = A + 1; // increment
            endcase
    end
endmodule