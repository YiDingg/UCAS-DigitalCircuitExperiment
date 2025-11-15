`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/16 15:50:27
// Design Name: 
// Module Name: db
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module db(
   input  wire clk,      // 系统时钟
    input  wire sw,   // 按键输入
    output wire db        // 消抖后的输出
);

    // 状态编码
    localparam [2:0]
        IDLE      = 3'b000,  // 空闲状态
        PRESS_S1  = 3'b001,  // 按下确认状态1
        PRESS_S2  = 3'b010,  // 按下确认状态2
        PRESS_S3  = 3'b011,  // 按下确认状态3
        PRESSED   = 3'b100,  // 按下稳定状态
        RELEASE_S1= 3'b101,  // 释放确认状态1
        RELEASE_S2= 3'b110,  // 释放确认状态2
        RELEASE_S3= 3'b111;  // 释放确认状态3

    // 计数器位宽（20位@100MHz时钟 ≈ 10ms）
    localparam CNT_WIDTH = 20;
    
    // 内部信号定义
    reg [2:0]            state_r = IDLE;  // 当前状态，上电初始化为IDLE
    reg [2:0]            next_state;      // 下一状态
    reg [CNT_WIDTH-1:0]  count_r = 0;     // 计数器，上电初始化为0
    wire                 time_up;          // 计时完成标志
    reg                  db_r;         // 输出寄存器

    // 计数器逻辑
    localparam MAX_COUNT = 20'hFFFFF;  // 20位全1
    assign time_up = (count_r == MAX_COUNT);
    
    always @(posedge clk) begin
        if (state_r != next_state)
            count_r <= 0;
        else if (count_r != MAX_COUNT)  // 防止溢出
            count_r <= count_r + 1;
    end

    // 状态寄存器
    always @(posedge clk) begin
        state_r <= next_state;
    end

    // 状态转换和输出逻辑
    always @(*) begin
        // 默认保持当前状态
        next_state = state_r;
        db_r = 1'b0;

        case (state_r)
            IDLE: begin
                if (sw)
                    next_state = PRESS_S1;
            end

            PRESS_S1: begin
                if (!sw)
                    next_state = IDLE;
                else if (time_up)
                    next_state = PRESS_S2;
            end

            PRESS_S2: begin
                if (!sw)
                    next_state = IDLE;
                else if (time_up)
                    next_state = PRESS_S3;
            end

            PRESS_S3: begin
                if (!sw)
                    next_state = IDLE;
                else if (time_up)
                    next_state = PRESSED;
            end

            PRESSED: begin
                db_r = 1'b1;
                if (!sw)
                    next_state = RELEASE_S1;
            end

            RELEASE_S1: begin
                db_r = 1'b1;
                if (sw)
                    next_state = PRESSED;
                else if (time_up)
                    next_state = RELEASE_S2;
            end

            RELEASE_S2: begin
                db_r = 1'b1;
                if (sw)
                    next_state = PRESSED;
                else if (time_up)
                    next_state = RELEASE_S3;
            end

            RELEASE_S3: begin
                db_r = 1'b1;
                if (sw)
                    next_state = PRESSED;
                else if (time_up)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // 输出赋值
    assign db = db_r;

endmodule
