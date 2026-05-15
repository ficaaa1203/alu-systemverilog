// 8-bit ALU with 9 operations and Z, N, V flags
module alu (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [3:0] op,
    output logic [7:0] result,
    output logic       Z,
    output logic       N,
    output logic       V
);

    // Operation codes
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam MUL  = 4'b0010;
    localparam DIV  = 4'b0011;
    localparam AND_ = 4'b0100;
    localparam OR_  = 4'b0101;
    localparam XOR_ = 4'b0110;
    localparam SHL  = 4'b0111;
    localparam SHR  = 4'b1000;

    // Signed views of operands
    wire signed [7:0]  A_s = A;
    wire signed [7:0]  B_s = B;

    // Full-width arithmetic
    wire [8:0]         add_full = {1'b0, A} + {1'b0, B};
    wire [8:0]         sub_full = {1'b0, A} - {1'b0, B};
    wire signed [15:0] mul_full = A_s * B_s;
    wire [7:0]         div_val  = (B == 8'b0) ? 8'hFF : (A_s / B_s);

    // Truncated 8-bit results (computed outside always_comb)
    wire [7:0] add_res = add_full[7:0];
    wire [7:0] sub_res = sub_full[7:0];
    wire [7:0] mul_res = mul_full[7:0];

    // Sign bits and overflow detection (computed outside always_comb)
    wire add_sign = add_full[7];
    wire sub_sign = sub_full[7];
    wire add_ovf  = (A[7] == B[7]) && (add_sign != A[7]);
    wire sub_ovf  = (A[7] != B[7]) && (sub_sign == B[7]);
    wire mul_hi_all_zero = (mul_full[15:7] == 9'b0);
    wire mul_hi_all_one  = (mul_full[15:7] == 9'b111111111);
    wire mul_ovf  = !(mul_hi_all_zero || mul_hi_all_one);

    // Shift amount (lower 3 bits of B)
    wire [2:0] shamt = B[2:0];

    always_comb begin
        result = 8'b0;
        V      = 1'b0;

        case (op)
            ADD:  begin result = add_res; V = add_ovf; end
            SUB:  begin result = sub_res; V = sub_ovf; end
            MUL:  begin result = mul_res; V = mul_ovf; end
            DIV:  begin result = div_val; V = 1'b0;    end
            AND_: result = A & B;
            OR_:  result = A | B;
            XOR_: result = A ^ B;
            SHL:  result = A << shamt;
            SHR:  result = A >> shamt;
            default: result = 8'b0;
        endcase

    end

    assign Z = (result == 8'b0);
    assign N = result[7];

endmodule