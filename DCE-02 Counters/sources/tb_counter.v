`timescale 1ns/1ps

`include "md_counter_syn_4bit.v"
`include "md_counter_asyn_4bit.v"
`include "md_counter_down_syn_4bit.v"

module tb_counter;
    // 时钟和复位信号
    reg clk;
    reg rst;
    
    // 三个计数器的输出
    wire [3:0] count_syn_up;
    wire [3:0] count_asyn_up;
    wire [3:0] count_syn_down;
    
    // 实例化三个计数器模块
    md_counter_syn_4bit u_syn_up(
        .clk(clk),
        .rst(rst),
        .count(count_syn_up)
    );
    
    md_counter_asyn_4bit u_asyn_up(
        .clk(clk),
        .rst(rst),
        .count(count_asyn_up)
    );

    md_counter_down_syn_4bit u_syn_down(
        .clk(clk),
        .rst(rst),
        .count(count_syn_down)
    );
    
    // 时钟生成：100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns周期
    end
    
    // 测试过程
    initial begin
        // 初始化
        rst = 1;
        
        // 生成VCD文件用于波形查看
        $dumpfile("counter_wave.vcd");
        $dumpvars(0, tb_counter);
        
        // 打印表头
        $display("==================================================================================");
        $display("Time(ns) | Sync_Up_Dec | Sync_Up_Bits | Async_Up_Dec | Async_Up_Bits | Sync_Down_Dec | Sync_Down_Bits");
        $display("==================================================================================");
        
        // 复位
        #20;
        rst = 0;
        
        // 运行足够多的时钟周期来观察行为
        #200;  // 20个时钟周期
        
        // 再次复位测试
        rst = 1;
        #30;
        rst = 0;
        #100;
        
        $display("==================================================================================");
        $finish;
    end
    
    // 实时显示计数器值
    integer last_syn_up = -1;
    integer last_asyn_up = -1;
    integer last_syn_down = -1;
    
    always @(posedge clk) begin
        // 只在值变化时显示，避免重复信息
        if (last_syn_up !== count_syn_up || last_asyn_up !== count_asyn_up || last_syn_down !== count_syn_down) begin
            $display("%8t | %11d |    %4b     | %12d |     %4b      | %13d |      %4b", 
                    $time,
                    count_syn_up, count_syn_up,
                    count_asyn_up, count_asyn_up,
                    count_syn_down, count_syn_down);
            
            last_syn_up = count_syn_up;
            last_asyn_up = count_asyn_up;
            last_syn_down = count_syn_down;
        end
    end
    
    // 监控异步计数器的纹波效应
    always @(count_asyn_up[0]) begin
        $display("           [Async Bit0 changed at %t ns]", $time);
    end
    
    always @(count_asyn_up[1]) begin
        $display("           [Async Bit1 changed at %t ns]", $time);
    end
    
    always @(count_asyn_up[2]) begin
        $display("           [Async Bit2 changed at %t ns]", $time);
    end
    
    always @(count_asyn_up[3]) begin
        $display("           [Async Bit3 changed at %t ns]", $time);
    end

endmodule