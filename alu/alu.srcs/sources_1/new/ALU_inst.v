module ALU_inst (inst_m, inst_s1, inst_s0, inst_A, inst_B, inst_out);
    input inst_m, inst_s1, inst_s0;
    input [3:0] inst_A, inst_B;
    output [3:0] inst_out;
    // instantiation of ALU module
    ALU U1 (.m(inst_m), .s1(inst_s1), .s0(inst_s0), .A(inst_A), .B(inst_B), .out(inst_out));
endmodule