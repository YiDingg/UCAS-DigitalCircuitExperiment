// sequence detector using state machine
// 2025.11.06 by YiDingg (https://www.zhihu.com/people/YiDingg)

module fsm(
    input clk,      // tell the machine when we should start
    input din,      // the signal we input
    input rst,      // restart
    output count,   // tell us the result
    output reg [2:0] st_cur
    );

    reg count_store;  // store the count

    parameter s_0 = 3'd0;   // 0
    parameter s_1 = 3'd1;   // 1
    parameter s_2 = 3'd2;   // 10
    parameter s_3 = 3'd3;   // 100
    parameter s_4 = 3'd4;   // 1001
    parameter s_5 = 3'd5;   // 10011
    parameter s_6 = 3'd6;   // 100110
    
    reg [2:0] st_next;
    
    // step 1:state transfer
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            st_cur <= 0;    // restart
        end else
        begin
            st_cur <= st_next;
        end
    end


    // step 2:state switch,using block assignment for combination_logic
    always @(*)begin
        case(st_cur)
            s_0:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_0;
                end
                
            s_1:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_2;
                end
            
            s_2:
                if(din)begin
                    st_next = s_3;
                end else
                begin
                    st_next = s_0;
                end
            
            s_3:
                if(din)begin
                    st_next = s_4;
                end else
                begin
                    st_next = s_2;
                end
        
            s_4:
                if(din)begin
                    st_next = s_5;
                end else
                begin
                    st_next = s_2;
                end
        
            s_5:
                if(din)begin
                    st_next = s_6;
                end else
                begin
                    st_next = s_2;
                end
        
            s_6:
                if(din)begin
                    st_next = s_1;
                end else
                begin
                    st_next = s_2;
                end
        endcase
    end
    
    // step 3: output logic,using non_block assignment
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            count_store <= 0;
        end else
        begin
            if(st_next == s_6)begin
                count_store <= 1;
            end else
            begin
                count_store <= 0;
            end
        end
    end
    
    assign count = count_store;
endmodule



/* // 2025.11.06 by YiDingg (https://www.zhihu.com/people/YiDingg)


`timescale 1ns / 1ps

module fsm(  
    input wire clk,
    input wire rst,      // 改为高电平复�??
    input wire din,
    output reg dout,
    output reg [2:0] state,
    output reg [7:0] array_now
);
    
    // states declaration
    localparam [2:0] s0 = 3'b000,    // idle
                    s1 = 3'b001,    // received 1
                    s2 = 3'b010,    // received 10  
                    s3 = 3'b011,    // received 101
                    s4 = 3'b100,    // received 1011
                    s5 = 3'b101,    // received 10111
                    s6 = 3'b110;    // received 101111 (match)
    
    reg [5:0] array_test;
    
    // target sequence: 101111
    // four possible preceding bits:
    // (00 101111)_2 = (47)_10
    // (01 101111)_2 = (111)_10
    // (10 101111)_2 = (175)_10
    // (11 101111)_2 = (239)_10

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            dout <= 0;
            state <= s0;
            array_test <= 6'b0;
            array_now <= 8'b0;
        end
        else begin
            // Shift in new data
            array_test <= {array_test[4:0], din};
            array_now <= {array_now[6:0], din};
            
            // Default assignments
            dout <= 0;
            state <= state;
            
            case(state)
                s0: begin
                    if(din == 1'b1) begin
                        state <= s1;
                    end
                end
                
                s1: begin
                    if(din == 1'b0) begin
                        state <= s2;
                    end else begin
                        state <= s1;
                    end
                end
                
                s2: begin
                    if(din == 1'b1) begin
                        state <= s3;
                    end else begin
                        state <= s0;
                    end
                end
                
                s3: begin
                    if(din == 1'b1) begin
                        state <= s4;
                    end else begin
                        state <= s2;
                    end
                end
                
                s4: begin
                    if(din == 1'b1) begin
                        state <= s5;
                    end else begin
                        state <= s2;
                    end
                end
                
                s5: begin
                    if(din == 1'b1) begin
                        state <= s6;
                        dout <= 1'b1;
                    end else begin
                        state <= s2;
                    end
                end
                
                s6: begin
                    if(din == 1'b1) begin
                        state <= s1;
                    end else begin
                        state <= s2;
                    end
                end
                
                default: begin
                    state <= s0;
                end
            endcase
        end
    end
endmodule

 */












/* 2025.11.06 by YiDingg (https://www.zhihu.com/people/YiDingg)


module fsm(
    input wire clk,
    input wire din,
    input wire rst,
    output reg dout,
    output reg [2:0] state,
    output reg [7:0] array_now=8'b0
    );
    
    //states claim
    localparam[2:0] s0 = 3'b000,    // (0)_10
                    s1 = 3'b001,    // (1)_10
                    s2 = 3'b010,    // (2)_10
                    s3 = 3'b011,    // (3)_10
                    s4 = 3'b100,    // (4)_10
                    s5 = 3'b101,    // (5)_10
                    s6 = 3'b110;    // (6)_10
    
    reg [5:0] array_test=6'b0;
    wire rst_n=~rst;
     
    always@(posedge clk or posedge rst_n) begin
        if(rst_n) begin
            dout<= 0;
            state<=s0;
            array_test<=6'b0;
            array_now<=8'b0;
        end
        else begin
            array_test={array_test[4:0], din};
            array_now={array_now[6:0], din};
            case(state)     // target sequence: 101111 (2023K8009908031)
                s0:begin
                    if(array_test[0]==1'b0)begin
                        state<=s0;                                               
                    end
                    else if(array_test[0]==1'b1)begin
                        state<=s1;                                                
                    end
                end
                s1:begin
                    if(array_test[1:0]==2'b10)begin
                        state<=s2;                                               
                    end
                    else if(array_test[1:0]==2'b11)begin
                        state<=s1;                       
                    end
                end
                s2:begin
                    if(array_test[2:0]==3'b101)begin
                        state<=s3;                       
                    end
                    else if(array_test[2:0]==3'b100)begin
                        state<=s0;
                    end
                end
                s3:begin
                    if(array_test[3:0]==4'b1011)begin
                        state<=s4;
                     end
                     else if(array_test[3:0]==4'b1010)begin
                        state<=s2;
                    end
                end
                s4:begin
                    if(array_test[4:0]==5'b10111)begin
                        state<=s5;
                    end
                    else if(array_test[4:0]==5'b10110)begin
                        state<=s2;
                    end
                end
                s5:begin
                    if(array_test==6'b101111)begin
                        state<=s6;
                        dout=1;
                    end
                    else if(array_test==6'b101110)begin
                        state<=s2;
                        dout=0;
                    end
                end
                s6:begin
                    if(array_test==6'b011111)begin
                        state<=s1;
                        dout=0;
                     end
                     else if(array_test==6'b011110)begin
                         state<=s2;
                         dout=0;
                     end
                 end
                 default:begin
                     state<=s0;
                     dout<=0;
                 end
             endcase
        end
    end
endmodule

*/