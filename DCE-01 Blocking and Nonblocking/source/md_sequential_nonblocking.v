
// (3) 时序 + 非阻塞赋值
// md_sequential_nonblocking.v

module md_sequential_nonblocking(
    input clk,
    input IN_A,
    input IN_B,
    input IN_D,
    output OUT_A0,
    output reg [1:0] OUT_E
);

// 1. Variable Declaration (变量声明)
reg [1:0] c = 0;  // 在 Verilog 中，reg 变量可以在声明时赋初始值（如 reg [1:0] c = 0;），但这主要用于仿真；在 FPGA 综合时，初始值通常被忽略，建议在 always 块中通过复位逻辑设置初始值以确保可综合性。

// 2. Main Code (主代码)
always @(posedge clk) begin
    c <= IN_A + IN_B;  // 非阻塞赋值：后语句可见前语句结果
    OUT_E <= c + IN_D;
end

// 3. Output Assignment (输出赋值)
assign OUT_A0 = IN_A;

endmodule

