`timescale 1ns / 1ps

module tb_sr();
    
    reg clk;
    reg rst;
    reg din;
    wire [7:0] on;
    wire [3:0] out;
    
    shift_reg uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .on(on),
        .out(out)
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
        
        $display("Time\tValue\tBinary\t\ton_reg\tout\tMatch");
        $display("--------------------------------------------------------");
        
        // Test specific target values that contain sequence "101111"
        test_value(8'd47);   // 00101111 - should match
        test_value(8'd111);  // 01101111 - should match  
        test_value(8'd175);  // 10101111 - should match
        test_value(8'd239);  // 11101111 - should match
        
        // Test some values that should NOT match
        test_value(8'd46);   // 00101110 - should NOT match
        test_value(8'd63);   // 00111111 - should NOT match
        test_value(8'd191);  // 10111111 - should NOT match
        
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
                $display("%0t\t-\t-\t\t%b\t%b", $time, on, out);
            end
            
            // Check result after complete byte is shifted in
            @(posedge clk);
            #1;
            if (out == 1) begin
                $display("*** SUCCESS: Sequence detected for value %d ***", value);
            end else begin
                $display("*** Sequence not detected for value %d ***", value);
            end
            
            // Wait between tests to observe
            repeat(4) @(posedge clk);
        end
    endtask

endmodule