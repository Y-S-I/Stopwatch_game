`timescale 1ns / 1ps


module tb_stopwatch;

    reg clk;
    reg reset;
    reg freeze;
    wire [3:0] AN;
    wire [6:0] digit_switch;
    
    stopwatch_game game_module (clk,reset,freeze,AN,digit_switch);
    
    always #5 clk=~clk;
    
    integer i;
    initial begin
        #10 clk=1;
        reset=1;
        freeze=0;
        for(i=0; i<1000_000 ; i=i+1)begin
            @(posedge clk);
        end
        reset=0;
//        for(i=0; i<10000_000 ; i=i+1)begin
//            @(posedge clk);
//        end
//        freeze=1;
//        for(i=0; i<1000_000 ; i=i+1)begin
//            @(posedge clk);
//        end
//        freeze=0;
//        for(i=0; i<1000_000 ; i=i+1)begin
//            @(posedge clk);
//        end
//        reset=1;
//        for(i=0; i<1000_000 ; i=i+1)begin
//            @(posedge clk);
//        end
//        reset=0;
//        for(i=0; i<10000_000 ; i=i+1)begin
//            @(posedge clk);
//        end
//        freeze=1;
    end
endmodule
