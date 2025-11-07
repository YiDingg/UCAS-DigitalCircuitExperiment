
module md_counter_syn_4bit(  // 4-bit synchronous up counter (同步加法计数器)
    input wire clk, 
    input wire rst, 
    output reg [3:0] count 
);
    
always@(posedge clk or posedge rst)begin 
    if(rst) begin
        count <= 4'b0;
    end else begin
        count <= count + 1'b1;
    end
end

endmodule



// NOT recommended style, for reference only:

/*
module md_counter_syn_4bit(  // 4-bit synchronous up counter (同步加法计数�?)
    input wire clk, 
    input wire rst, 
    output reg [3:0] count 
    ); 
    
    always@(posedge clk or posedge rst)begin 
        if(rst) 
            count[0]<=0; 
        else 
            count[0]<=~count[0]; 
    end 
    always@(posedge clk or posedge rst)begin 
        if(rst) 
            count[1]<=0; 
        else if(count[0]) 
            count[1]<=~count[1]; 
    end 
    always@(posedge clk or posedge rst)begin 
        if(rst) 
            count[2]<=0; 
        else if(count[0]&count[1]) 
            count[2]<=~count[2]; 
    end 
    always@(posedge clk or posedge rst)begin 
        if(rst) 
            count[3]<=0; 
        else if(count[0]&count[1]&count[2]) 
            count[3]<=~count[3]; 
    end 

endmodule
*/