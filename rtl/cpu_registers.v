//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall & Ryan Cooke
//
// Create Date: 03/07/2018
// Design Name: cpu_registers.v
// Module Name: cpu_registers
// Project Name: chip_8_hdl
// Target Devices: icestick
// Tool Versions: icestorm
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module cpu_registers(
           input				clk,
           input        rst,

           input		[3:0]	x,      // selects register Vx, where x points to the address
           input		[3:0]	y,      // selects register Vy, where y points to the address

           output	    [7:0]	Vx,
           output	    [7:0]	Vy,
           output	    [7:0]	Vf,

           input pc_inc,
           input sp_inc,
           input sp_dec,
           output   [15:0] pc_out,
           output   [15:0] sp_out,


           input				wx,     // Vx write enable
           input		[7:0]	nx,     // new Vx data

           input				wf,     // Vf write enable
           input		[7:0]	nf      // new Vf data
       );

reg [7:0] Vreg [0:15];

reg [15:0] pc = 16'h0; //program counter, holds address of current instruction
reg [7:0] sp = 8'd0; //stack pointer, holds address of top of stack, stack starts at 0xEA0
localparam STACK_OFFSET = 16'd240;

assign Vx = Vreg[x];
assign Vy = Vreg[y];
assign Vf = Vreg[15];

always @ (posedge clk) begin
    if (wx)
        Vreg[x] <= nx;
    if (wf)
        Vreg[15] <= nf;
    if (pc_inc)
        pc += 1; //instructions are 2 bytes, and each address addresses only 1 byte
    if (sp_inc)
        sp += 1;
    if (sp_dec)
        sp -= 1;
end

assign pc_out = pc;
assign sp_out = STACK_OFFSET + sp;

endmodule
