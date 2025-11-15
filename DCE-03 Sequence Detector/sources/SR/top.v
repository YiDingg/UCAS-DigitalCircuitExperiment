module top(
    input clk,//clock of sysytem
    input s0,//signal press
    input rst,//signal:restart
    input SW0,//signal:din
    input [3:0] ctrl,
    output [7:0] on,//output of reg
    output [7:0] sseg,//output reflects on the led
    output wire[3:0] an
    );
    
    assign an = ctrl;
    wire s0_o;
    wire rst_o;
    wire [3:0]out_o;
    
    db db_fsm_clk(
    .clk(clk),
    .sw(s0),
    .db(s0_o)
    );
    
    db db_fsm_rst(
    .clk(clk),
    .sw(!rst),
    .db(rst_o)
    );
    
    shift_reg shift_reg(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .out(out_o),
    .on(on)
    );
    
    hex_7seg hex_7seg(
    .hex(out_o),
    .dp(0),
    .sseg(sseg)
    );
    
    
endmodule    
    

