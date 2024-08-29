`timescale 1ns / 1ps


module display_unit
    (clk,timer,AN,digit_switch);
    input clk;     
    input [15:0] timer;
    output [3:0] AN;
    output [6:0] digit_switch;
    
    reg [3:0] AN=4'b0111;
    reg [6:0] digit_switch=7'b1000000;
    reg [6:0] dig0;
    reg [6:0] dig1;
    reg [6:0] dig2;
    reg [6:0] dig3;
    
    
    reg enable=1'b0;
    reg score_enable=1'b0;
    reg[14:0] one_milli='d0;
    
    wire [6:0] hex_dig0;
    wire [6:0] hex_dig1;
    wire [6:0] hex_dig2;
    wire [6:0] hex_dig3;
    
    
    bcd_to_hex convert0 (timer[3:0],hex_dig0);
    bcd_to_hex convert1 (timer[7:4],hex_dig1);
    bcd_to_hex convert2 (timer[11:8],hex_dig2);
    bcd_to_hex convert3 (timer[15:12],hex_dig3);
    
    always@(posedge clk)begin
        if(enable)
            enable <= 1'b0;
        else
            one_milli <= one_milli + 1'b1;
        if(one_milli + 1'b1 == 'd20000)begin
            enable <= 1'b1;
            one_milli <= 'd0;
        end
    end
    
    always@(posedge clk)begin
        if(enable)begin
            AN <= {AN[0],AN[3:1]};
            dig3 <= hex_dig0;
            dig2 <= hex_dig1;
            dig1 <= hex_dig2;
            dig0 <= hex_dig3;
        end
    end
    
    always@(*)begin
        case(AN)
            4'b0111: digit_switch = dig0;
            4'b1011: digit_switch = dig1;
            4'b1101: digit_switch = dig2;
            4'b1110: digit_switch = dig3;
            default: digit_switch = 7'b0001110;
        endcase
    end
endmodule