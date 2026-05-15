`timescale 1ns/1ps

module alu_tb;
    logic [7:0] A, B;
    logic [3:0] op;
    logic [7:0] result;
    logic Z, N, V;

    // Instantiate the ALU
    alu dut (
        .A(A), .B(B), .op(op),
        .result(result),
        .Z(Z), .N(N), .V(V)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        $display("op   | A         B         | result    | Z N V");
        $display("-----+---------------------+-----------+------");

        // ADD
        A=8'd10;  B=8'd20;  op=4'b0000; #1;
        $display("ADD  | %0d        %0d        | %0d        | %b %b %b", $signed(A), $signed(B), $signed(result), Z, N, V);

        A=8'd127; B=8'd1;   op=4'b0000; #1;
        $display("ADD  | %0d       %0d         | %0d       | %b %b %b  <- overflow", $signed(A), $signed(B), $signed(result), Z, N, V);

        // SUB
        A=8'd30;  B=8'd10;  op=4'b0001; #1;
        $display("SUB  | %0d        %0d        | %0d        | %b %b %b", $signed(A), $signed(B), $signed(result), Z, N, V);

        A=8'd0;   B=8'd1;   op=4'b0001; #1;
        $display("SUB  | %0d         %0d         | %0d        | %b %b %b  <- negative", $signed(A), $signed(B), $signed(result), Z, N, V);

        // MUL
        A=8'd5;   B=8'd6;   op=4'b0010; #1;
        $display("MUL  | %0d         %0d         | %0d        | %b %b %b", $signed(A), $signed(B), $signed(result), Z, N, V);

        A=8'd50;  B=8'd10;  op=4'b0010; #1;
        $display("MUL  | %0d        %0d        | %0d        | %b %b %b  <- overflow", $signed(A), $signed(B), $signed(result), Z, N, V);

        // DIV
        A=8'd100; B=8'd4;   op=4'b0011; #1;
        $display("DIV  | %0d       %0d         | %0d        | %b %b %b", $signed(A), $signed(B), $signed(result), Z, N, V);

        A=8'd50;  B=8'd0;   op=4'b0011; #1;
        $display("DIV  | %0d        %0d         | %0d       | %b %b %b  <- div by zero", $signed(A), $signed(B), $signed(result), Z, N, V);

        // Logic
        A=8'hF0;  B=8'h0F;  op=4'b0100; #1;
        $display("AND  | 0x%02h      0x%02h      | 0x%02h      | %b %b %b", A, B, result, Z, N, V);

        A=8'hF0;  B=8'h0F;  op=4'b0101; #1;
        $display("OR   | 0x%02h      0x%02h      | 0x%02h      | %b %b %b", A, B, result, Z, N, V);

        A=8'hFF;  B=8'h0F;  op=4'b0110; #1;
        $display("XOR  | 0x%02h      0x%02h      | 0x%02h      | %b %b %b", A, B, result, Z, N, V);

        // Shifts
        A=8'b00001111; B=8'd2; op=4'b0111; #1;
        $display("SHL  | 0x%02h      shift=%0d   | 0x%02h      | %b %b %b", A, B[2:0], result, Z, N, V);

        A=8'b11110000; B=8'd2; op=4'b1000; #1;
        $display("SHR  | 0x%02h      shift=%0d   | 0x%02h      | %b %b %b", A, B[2:0], result, Z, N, V);

        // Zero flag check
        A=8'd5;   B=8'd5;   op=4'b0001; #1;
        $display("SUB  | %0d         %0d         | %0d         | %b %b %b  <- zero flag", $signed(A), $signed(B), $signed(result), Z, N, V);

        $finish;
    end
endmodule