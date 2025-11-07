`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 15:55:01
// Design Name: 
// Module Name: hex
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


module hex(
     input [3:0]hex,
    input dp,
    
    output reg [7:0] sseg
    );
    
    always@* begin
        case(hex)
            4'h0:sseg[6:0]=7'b1111110;
            4'h1:sseg[6:0]=7'b0110000;
            4'h2:sseg[6:0]=7'b1101101;
            4'h3:sseg[6:0]=7'b1111001;
            4'h4:sseg[6:0]=7'b0110011;
            4'h5:sseg[6:0]=7'b1011011;
            4'h6:sseg[6:0]=7'b1011111;
            4'h7:sseg[6:0]=7'b1110000;
            4'h8:sseg[6:0]=7'b1111111;
            4'h9:sseg[6:0]=7'b1111011;
            4'ha:sseg[6:0]=7'b1110111;
            4'hb:sseg[6:0]=7'b0011111;
            4'hc:sseg[6:0]=7'b1001110;
            4'hd:sseg[6:0]=7'b0111101;
            4'he:sseg[6:0]=7'b1001111;
            4'hf:sseg[6:0]=7'b1000111;
            default:sseg[6:0]=7'b1111111;
        endcase
        sseg[7]=dp;
    end
endmodule
