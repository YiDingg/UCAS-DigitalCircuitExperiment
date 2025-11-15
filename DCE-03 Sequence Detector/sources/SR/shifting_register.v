module shift_reg(
    input clk,
    input din,
    input rst,
    output reg [7:0] on,
    output reg [3:0] out
    );
    
    reg count = 0;
    
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            on <= 0;
            out<= 0;
        end else
        begin
            on[7:0] <= {on[6:0],din};
            case({on[4:0],din})
                6'b101111: out <= 1;
                default:   out <= 0;
            endcase
        end
    end
endmodule
