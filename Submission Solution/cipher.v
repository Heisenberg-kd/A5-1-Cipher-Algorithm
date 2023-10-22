`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2022 20:41:33
// Design Name: 
// Module Name: cipher
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


module cipher(
    input clk,
    input reset,
    input key_in,
    input bit_in,
    output bit_out,
    output reg ready //signifies that the LFSRs have been loaded and clocked 100 times
    );
    
    reg [18:0] x; //LFSR 1
    reg [21:0] y; //LFSR 2
    reg [22:0] z; //LFSR 3
    reg [7:0] count; //counter to count number of cycles for loading and clocking LFSRs
    wire shift; //output from the majority logic
    
    majority M(x[8], y[10], z[10], shift);
    assign bit_out = x[18] ^ y[21] ^ z[22] ^ bit_in;
    
    
    always@(posedge clk, posedge reset)
    begin
        if(reset) begin
            count <= 186; //64+22+100
            x <= 0;
            y <= 0;
            z <= 0;
            ready <= 0;
        end
        
        if(count > 100) begin //loading the LFSRs
            x[0] <= x[13]^x[16]^x[17]^x[18] ^ key_in;
            x[18:1] <= x[17:0];
            y[0] <= y[20] ^ y[21] ^ key_in;
            y[21:1] <= y[20:0];
            z[0] <= z[7]^z[20]^z[21]^z[22] ^ key_in;
            z[22:1] <= z[21:0];
            
            count <= count - 1;
            ready <= 0;
        end
        
        else if(count > 0) begin //clocking the LFSRs with majority logic
            count <= count - 1;
            ready <= 0;
            if(x[8] == shift) x <= {x[17:0],{x[13]^x[16]^x[17]^x[18]}};
            if(y[10] == shift) y <= {y[20:0],{y[20]^y[21]}};
            if(z[10] == shift) z <= {z[21:0],{z[7]^z[20]^z[21]^z[22]}};
        end
        else begin
            ready <= 1; //LFSRs have been initialized and it is ready to start encrypting
            if(x[8] == shift) x <= {x[17:0],{x[13]^x[16]^x[17]^x[18]}};
            if(y[10] == shift) y <= {y[20:0],{y[20]^y[21]}};
            if(z[10] == shift) z <= {z[21:0],{z[7]^z[20]^z[21]^z[22]}};
        end
    end
    
endmodule
