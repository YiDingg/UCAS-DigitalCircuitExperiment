module md_counter_down_syn_4bit(    // 4-bit synchronous down counter (同步减法计数器)
    input wire clk, 
    input wire rst, 
    output reg [3:0] count 
);

    // 同步计数器使用单个 always 块，代码简洁清晰
    always@(posedge clk or posedge rst) begin 
        if(rst) 
            count <= 4'b1111;          // 复位到最大值(15)
        else 
            count <= count - 4'b0001;  // 每个时钟周期减1
    end

endmodule

/* 
module md_counter_down_syn_4bit(    // 4-bit synchronous down counter (同步减法计数器)
    input wire clk, 
    input wire rst, 
    output reg [3:0] count=4'b1111  // initialize to (1111)_2
    );

    always@(posedge clk or posedge rst)begin 
        if(rst)begin 
            count[3]<=1'b1; 
            count[2]<=1'b1; 
            count[1]<=1'b1; 
            count[0]<=1'b1;             
        end  
        else begin 
            count[0]<=~count[0];         
            if(~count[0])begin 
                count[1]<=~count[1]; 
            end 
            if(~count[0]&&~count[1])begin 
                count[2]<=~count[2]; 
                count[1]<=~count[1]; 
            end 
            if(~count[2]&&~count[1]&&~count[0])begin 
                count[3]<=~count[3]; 
                count[2]<=~count[2]; 
                count[1]<=~count[1]; 
            end             
        end 
    end       

endmodule
*/