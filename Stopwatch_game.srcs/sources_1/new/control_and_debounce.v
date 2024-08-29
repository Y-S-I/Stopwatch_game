`timescale 1ns / 1ps



module control_and_debounce(clk,reset,freeze,debounced_reset,debounced_freeze);
    input clk;
    input reset;
    input freeze;
    output reg debounced_reset;
    output reg debounced_freeze;

    localparam enable_count = 20000;// 1ms per cycle
    reg [7:0] shift_reset  = 8'b0;
    reg [7:0] shift_freeze = 8'b0;
    reg enable=1'b0;
    reg [14:0] counter='d0;
    
    // sampling with lower frequency clock 1KHz 
    // because we don't want to sample too quickly as debounce period
    // is of approx 10ms
    always@(posedge clk) begin
        counter <= counter + 1'b1;
        if(counter == enable_count - 1'b1)begin
            counter <= 'd0;
            enable <= 1'b1;
        end
        else begin
            enable <= 1'b0;
        end
    end
    
    // we need debounce for both push and release
    always@(posedge clk) begin
        if(enable)begin
            shift_reset <= {shift_reset[6:0],reset};
            //      __   _   _________________
            //     |  | | | |
            //     |  | | | |
            // ____|  |_| |_|
            if(&shift_reset)
                debounced_reset <= 1'b1;
            //                  ______________   __   _
            //                                | |  | | |
            //                                | |  | | |
            //                                |_|  |_| |___________
            else if(~(|shift_reset))
                debounced_reset <= 1'b0;
        end
    end
    
    // here we need debounce for push only
    // because reset will be used to clear debounced_freeze output   
    always@(posedge clk) begin
        if(debounced_reset)
            debounced_freeze <= 1'b0;
        else if(enable) begin
            shift_freeze <= {shift_freeze[6:0],freeze};
            if(&shift_freeze)
                debounced_freeze <= 1'b1;
        end
    end
    
endmodule
