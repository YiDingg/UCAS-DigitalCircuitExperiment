`timescale 1ns / 1ps

module tb_fsm();
    
    reg clk;
    reg rst;
    reg din;
    wire dout;
    wire [2:0] state;
    wire [7:0] array_now;
    
    fsm uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout),
        .state(state),
        .array_now(array_now)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        din = 0;
        
        // Reset
        #20;
        rst = 0;
        #10;
        
        $display("Time\tValue\tBinary\t\tState\tdout\tMatch");
        $display("------------------------------------------------");
        
        // Test specific target values
        test_value(8'd47);   // 00101111 - should match
        test_value(8'd111);  // 01101111 - should match  
        test_value(8'd175);  // 10101111 - should match
        test_value(8'd239);  // 11101111 - should match
        
        #100;
        $display("=== Test Complete ===");
        $finish;
    end
    
    task test_value;
        input [7:0] value;
        integer i;
        begin
            $display("--- Testing value %d (%b) ---", value, value);
            
            // Send 8 bits MSB first
            for (i = 7; i >= 0; i = i - 1) begin
                din = value[i];
                @(posedge clk);
                #1;
                $display("%0t\t-\t-\t\t%d\t%b", $time, state, dout);
            end
            
            // Check result
            @(posedge clk);
            #1;
            if (dout) begin
                $display("*** SUCCESS: Sequence detected for value %d ***", value);
            end else begin
                $display("*** FAIL: Sequence not detected for value %d ***", value);
            end
            
            // Wait between tests
            repeat(4) @(posedge clk);
        end
    endtask

endmodule