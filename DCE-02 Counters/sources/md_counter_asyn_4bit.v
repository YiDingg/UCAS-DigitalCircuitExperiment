module md_counter_asyn_4bit(    // 4-bit asynchronous up counter (异步加法计数器)
    input wire clk, 
    input wire rst, 
    output reg [3:0] count 
);
    
    // 异步计数器 "必须" 使用多个 always 块，因为每级时钟不同
    always@(posedge clk or posedge rst)begin 
        if(rst) 
            count[0]<=0; 
        else 
            count[0]<=~count[0]; 
    end 
    always@(posedge ~count[0] or posedge rst)begin 
        if(rst) 
            count[1]<=0; 
        else 
            count[1]<=~count[1]; 
    end 
    always@(posedge ~count[1] or posedge rst)begin 
        if(rst) 
            count[2]<=0; 
        else  
            count[2]<=~count[2]; 
    end 
    always@(posedge ~count[2] or posedge rst)begin 
        if(rst) 
            count[3]<=0; 
        else  
            count[3]<=~count[3]; 
    end 

endmodule

