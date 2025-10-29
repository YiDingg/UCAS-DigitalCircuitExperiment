
// Testbench for both sequential modules simultaneously

`timescale 1ns/1ps 

module tb_sequential_both;

// 1. Variable Declaration (变量声明)
reg clk;
reg in_a;
reg in_b;
reg in_d;
wire out_a0_blocking;
wire [1:0] out_e_blocking;
wire out_a0_nonblocking;
wire [1:0] out_e_nonblocking;

parameter PERIOD = 20;

// 2. Instantiate the Units Under Test (UUTs)
md_sequential_blocking uut_blocking (
    .clk(clk),
    .IN_A(in_a),
    .IN_B(in_b),
    .IN_D(in_d),
    .OUT_A0(out_a0_blocking),
    .OUT_E(out_e_blocking)
);

md_sequential_nonblocking uut_nonblocking (
    .clk(clk),
    .IN_A(in_a),
    .IN_B(in_b),
    .IN_D(in_d),
    .OUT_A0(out_a0_nonblocking),
    .OUT_E(out_e_nonblocking)
);

// 3. Testbench Logic (测试逻辑)
initial begin
    // Clock generation (时钟生成)
    clk = 1'b0;
    #(PERIOD/2);
    forever #(PERIOD/2) clk = ~clk;
end

integer delay1_a, delay2_a, k_a;
initial begin
    // Initialize Inputs (初始化输入)
    in_a = 0;
    in_b = 0;
    in_d = 0;
    #10;
    // Generate random signals for in_a (生成 in_a 的随机信号)
    for(k_a = 0; k_a < 200; k_a = k_a + 1) begin
        delay1_a = (PERIOD/3) * ({$random} % 3);
        delay2_a = (PERIOD/3) * ({$random} % 3);
        #delay1_a in_a = 1;
        #delay2_a in_a = 0;
    end
end

integer delay1_b, delay2_b, k_b;
initial begin
    // Generate random signals for in_b (生成 in_b 的随机信号)
    #10 in_b = 0;
    for(k_b = 0; k_b < 200; k_b = k_b + 1) begin
        delay1_b = (PERIOD/3) * ({$random} % 5);
        delay2_b = (PERIOD/3) * ({$random} % 5);
        #delay1_b in_b = 1;
        #delay2_b in_b = 0;
    end
end

integer delay1_d, delay2_d, k_d;
initial begin
    // Generate random signals for in_d (生成 in_d 的随机信号)
    #10 in_d = 0;
    for(k_d = 0; k_d < 200; k_d = k_d + 1) begin
        delay1_d = (PERIOD/3) * ({$random} % 6);
        delay2_d = (PERIOD/3) * ({$random} % 6);
        #delay1_d in_d = 1;
        #delay2_d in_d = 0;
    end
end

// 4. Monitor Outputs (监测输出)
initial begin
    $monitor("Time: %0t | clk: %b | IN_A: %b | IN_B: %b | IN_D: %b | Blocking OUT_A0: %b | OUT_E: %b | Nonblocking OUT_A0: %b | OUT_E: %b", $time, clk, in_a, in_b, in_d, out_a0_blocking, out_e_blocking, out_a0_nonblocking, out_e_nonblocking);
end

endmodule


