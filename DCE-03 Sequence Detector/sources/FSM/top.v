module top( // top module of the FSM sequence detector
    input clk,  // clock of sysytem
    input s0,   // signal press
    input rst,  // signal:restart
    input SW0,  // signal:din
    input  [3:0] ctrl, // control signal for anode
    output [7:0] on,   // output of reg
    output [7:0] sseg, // output reflects on the led
    output wire [3:0] an,
    output wire [2:0] st,
    output wire debug
    );
    
    assign an = ctrl;
    wire s0_o;
    wire rst_o;
    wire count_o;
    
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
    
    LD LD(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .on(on)
    );
    
    fsm fsm(
    .clk(s0_o),
    .rst(rst_o),
    .din(SW0),
    .count(count_o),
    .st_cur(st)
    );
    
    hex_7seg hex_7seg(
    .hex(count_o),
    .dp(0),
    .sseg(sseg)
    );
    
    assign debug = s0;
endmodule
    
    

