`timescale 1ns / 1ps


module BCD_Timer(clk,reset,freeze,timer);

    input clk;
    input reset;
    input freeze;
    output [15:0] timer;
    
    reg [3:0] ten_milli='d0;
    reg [3:0] hundred_milli='d0;
    reg [3:0] one_sec='d0;
    reg [3:0] ten_sec='d0;
    
    reg inc_2nd_digit=1'b0;
    reg inc_3rd_digit=1'b0;
    reg inc_4th_digit=1'b0;
    
    reg [17:0] counter='d0;
    
    localparam COUNT_FOR_10_MS = 200000;
    
    assign timer = {ten_sec,one_sec,hundred_milli,ten_milli};
    
    always@(posedge clk)begin
        if(reset)begin
            ten_milli <= 'd0;
            inc_2nd_digit<=1'b0;
            counter <= 'd0;
        end
        else begin
            if(freeze)
                inc_2nd_digit<=1'b0;
            else begin
                counter <= counter + 1'b1;
                inc_2nd_digit <= 1'b0;
                if(counter == COUNT_FOR_10_MS-1)begin
                    counter <= 'd0;
                    if(ten_milli < 'd9)begin
                        ten_milli <= ten_milli + 1'b1;    
                    end
                    else begin
                        ten_milli <= 'd0;    
                        inc_2nd_digit <= 1'b1;
                    end
                end
            end
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            hundred_milli <= 'd0;
            inc_3rd_digit<=1'b0;
        end
        else begin
            inc_3rd_digit <= 1'b0;
            if(inc_2nd_digit) begin
                if(hundred_milli < 'd9)begin
                    hundred_milli <= hundred_milli + 1'b1;    
                end
                else begin
                    hundred_milli <= 'd0;    
                    inc_3rd_digit <= 1'b1;
                end
            end    
        end
    end
    
    always@(posedge clk)begin
        if(reset)begin
            one_sec <= 'd0;
            inc_4th_digit<=1'b0;
        end
        else begin
            inc_4th_digit<=1'b0;
            if(inc_3rd_digit) begin
                if(one_sec < 'd9)begin
                    one_sec <= one_sec + 1'b1;    
                end
                else begin
                    one_sec <= 'd0;    
                    inc_4th_digit <= 1'b1;
                end
            end
        end
    end
    
    always@(posedge clk)begin
        if(reset)
            ten_sec <= 'd0;
        else begin
            if(inc_4th_digit)begin
                if(ten_sec < 'd9)begin
                    ten_sec <= ten_sec + 1'b1;    
                end
                else begin
                    ten_sec <= 'd0;    
                end
            end
        end
    end
endmodule
