// A simple testbench for the ALU
`timescale 1ns/100ps
module TB_ALU;
reg m_tb, s1_tb, s0_tb;
reg [3:0] A_tb, B_tb;
wire [3:0] out_tb;
ALU U0(.m(m_tb), .s1(s1_tb), .s0(s0_tb), .A(A_tb), .B(B_tb), .out(out_tb));
initial
    begin
        m_tb = 0;
        s1_tb = 0;
        s0_tb = 0;
        A_tb = 4'b0000;
        B_tb = 4'b0000;
        
        #60 A_tb = 4'b1010;
            B_tb = 4'b0111;
        #50 s0_tb = 1;
        #50 s1_tb = 1;
        #50 s0_tb = 0;
        #50 m_tb = 1;
        #50 s0_tb = 1;
        #50 s1_tb = 0;
        #50 s0_tb = 0;
        
        #50 $stop;
        #20 $finish;
    end
endmodule

// An self-checking testbenchfor the ALU
`timescale 1ns/1ns
module TB_ALU;
    reg [3:0] A_tb;
    reg [3:0] B_tb;
    reg m_tb, s1_tb, s0_tb;
    reg [3:0] A_tb_array [999:0];
    reg [3:0] B_tb_array [999:0];
    reg m_tb_array [999:0];
    reg s1_tb_array [999:0];
    reg s0_tb_array [999:0];
    reg [3:0] Result_array [999:0];
    wire [3:0] out_tb;
    parameter Iterations = 1000;
    ALU DUT( .m(m_tb),
    .s1(s1_tb),
    .s0(s0_tb),
    .A(A_tb),
    .B(B_tb),
    .out(out_tb) );
    integer OUTPUT_FILE;
    integer ERROR_COUNT;
    integer CORRECT_COUNT;
    integer i, j; //used in for_loops
    initial
        begin
        ERROR_COUNT=0;
        CORRECT_COUNT=0;
        OUTPUT_FILE=$fopen("results.txt");
        GEN_INPUT(Iterations);
        for (j = 0; j < Iterations; j = j + 1)
            begin
            A_tb = A_tb_array[j];
            B_tb = B_tb_array[j];
            m_tb = m_tb_array[j];
            s1_tb = s1_tb_array[j];
            s0_tb = s0_tb_array[j];
            #100
            CHECK_out(Result_array[j]);
            end
        if (ERROR_COUNT == 0) begin
        $display("No errors or warnings");
        $fdisplay(OUTPUT_FILE,"No errors or warnings");
        end else begin
        $display("%d errors found in simulation",ERROR_COUNT);
        $fdisplay(OUTPUT_FILE,"%d errors found in simulation",ERROR_COUNT);
        end
        $fclose(OUTPUT_FILE);
        $stop;
        end
        //generate random inputs and expected results
        task GEN_INPUT;
        input [31:0] times;
        for (i = 0; i < times; i = i + 1)
        begin
        A_tb_array[i] = $random;
        B_tb_array[i] = $random;
        m_tb_array[i] = $random;
        s1_tb_array[i] = $random;
        s0_tb_array[i] = $random;
        case({m_tb_array[i], s1_tb_array[i], s0_tb_array[i]})
        0: Result_array[i] = ~A_tb_array[i];
        1: Result_array[i] = A_tb_array[i] & B_tb_array[i];
        2: Result_array[i] = A_tb_array[i] ^ B_tb_array[i];
        3: Result_array[i] = A_tb_array[i] | B_tb_array[i];
        4: Result_array[i] = A_tb_array[i] - 1;
        5: Result_array[i] = A_tb_array[i] + B_tb_array[i];
        6: Result_array[i] = A_tb_array[i] - B_tb_array[i];
        7: Result_array[i] = A_tb_array[i] + 1;
        endcase
        end
        endtask
        //verify results
        task CHECK_out;
        input [3:0] EXPECTED_OUT;
        #0 begin
        if (EXPECTED_OUT !== out_tb) begin
        $display("Error at time=%dns actual=%b, expected=%b",
        $time, out_tb, EXPECTED_OUT);
        $fdisplay(OUTPUT_FILE,"Error at time=%dns actual=%b, expected=%b", $time, out_tb, EXPECTED_OUT);
        ERROR_COUNT = ERROR_COUNT + 1;
        end
        else begin
        CORRECT_COUNT = CORRECT_COUNT + 1;
        end
        end
    endtask
endmodule