`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2022 11:11:19
// Design Name: 
// Module Name: majority
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


module majority(
    input a,
    input b,
    input c,
    output reg major
    );
    
    always@(*)
    begin
        case({a,b,c})
            3'b000: major = 0;
            3'b001: major = 0;
            3'b010: major = 0;
            3'b011: major = 1;
            3'b100: major = 0;
            3'b101: major = 1;
            3'b110: major = 1;
            3'b111: major = 1;
        endcase
    end
endmodule
