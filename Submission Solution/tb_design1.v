`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2022 18:36:26
// Design Name: 
// Module Name: tb_design1
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


module tb_design1(

    );
    parameter half_cc = 5;
    
    //inputs
    reg clk, reset, key_in, bit_in;
    
    //outputs
    wire bit_out, ready;
    
    integer i,j;
    reg [7:0] img [65535:0];
    reg [63:0] secret;
    reg [21:0] public;
    
    cipher uut(clk, reset, key_in, bit_in, bit_out, ready);
    
    always #5 clk = ~clk;
    
    initial begin
        secret = 64'h68_61_72_64_77_61_72_65;
        public = 22'b11_0100_1110_0001_1001_0001;
        clk = 0;
        reset = 0;
        key_in = 0;
        bit_in = 0;
        
        $readmemh("path\\to\\input_image.txt", img); //for decryption, give path to encrypted image txt file
        
        #1 reset = 1; //reset all the LFSRs and start loading the keys 
        #2 reset = 0;
        
        for(i = 63; i>=0; i=i-1)
        begin: feed_secret_key
            key_in = secret[i];
            #(2*half_cc);
        end
        
        for(i = 21; i>=0; i=i-1)
        begin: feed_public_key
            key_in = public[i];
            #(2*half_cc);
        end
        
        wait(ready); //wait until the LFSRs are clocked 100 times
        
        for(i=0; i<65536; i=i+1) begin
            for(j=0; j<8; j=j+1) begin
                bit_in = img[i][j]; //give input bit
                #(half_cc) img[i][j] = bit_out; //store output bit back in same memory
                #(half_cc);
            end
        end
        
        $writememh("path\\to\\encrypted_image.txt", img); //for decryption give path to decrypted image txt file
        
        #(half_cc) $finish;
    end
    
endmodule
