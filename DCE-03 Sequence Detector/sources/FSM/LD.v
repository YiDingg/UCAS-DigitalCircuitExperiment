//Displacement register module
module LD(
    input clk,
    input din,
    input rst,
    output reg [7:0]on
    );
    always @(posedge clk or negedge rst)begin
        if(rst)begin
            on <= 0;
        end else
        begin
            on <= {on[6:0],din};
        end
    end
endmodule