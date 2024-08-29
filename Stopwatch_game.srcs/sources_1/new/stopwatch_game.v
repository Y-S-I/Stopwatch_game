`timescale 1ns / 1ps


module stopwatch_game(clk_100MHz,reset,freeze,AN,digit_switch);
    input clk_100MHz;
    input reset;
    input freeze;
    output [3:0] AN;
    output [6:0] digit_switch;
    
    wire clk_20MHz;
    wire [15:0] timer;
    wire debounced_reset;
    wire debounced_freeze;    
    clk_wiz_0 clock_divider
   (
    // Clock out ports
    .clk_20MHz(clk_20MHz),     // output clk_20MHz
   // Clock in ports
    .clk_100MHz(clk_100MHz));
    
    
    BCD_Timer timer_module (clk_20MHz,debounced_reset,debounced_freeze,timer);
    
    control_and_debounce  control_module (clk_20MHz,reset,freeze,debounced_reset,debounced_freeze);
    
    display_unit display_module (clk_20MHz,timer,AN,digit_switch);
 
endmodule
