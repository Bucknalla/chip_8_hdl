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
    input clk,
    input rst,

    input [3:0]	i_vx_addr,      // selects register o_vx_data, where i_vx_addr points to the address
    input [3:0]	i_vy_addr,      // selects register o_vy_data, where i_vy_addr points to the address

    output [7:0] o_vx_data,
    output [7:0] o_vy_data,
    output [7:0] o_vf_data,

    input i_pc_en,
    input i_sp_en,

    input [15:0] i_pc_data,
    input [7:0] i_sp_data,
    output   [15:0] o_pc_data,
    output   [7:0] o_sp_data,

    input [15:0] i_i_data,
    input i_i_en,
    output [15:0] o_i_rd,

    input i_vx_en,     // o_vx_data write enable
    input [7:0] i_vx_data,     // new o_vx_data data

    input i_vf_en,     // o_vf_data write enable
    input i_vf_data      // new o_vf_data data
    );

reg [7:0] Vreg [0:15];
reg [15:0] i;

reg [15:0] pc = 16'h0; //program counter, holds address of current instruction
reg [7:0] sp = 8'd0; //stack pointer, holds address of top of stack, stack starts at 0xEA0
localparam STACK_OFFSET = 16'd240;

assign o_vx_data = Vreg[i_vx_addr];
assign o_vy_data = Vreg[i_vy_addr];
assign o_vf_data = Vreg[15];

always @ (posedge clk) begin
    if (i_vx_en)
        Vreg[i_vx_addr] <= i_vx_data;
    if (i_vf_en)
        Vreg[15] <= i_vf_data;
    if (i_pc_en)
        pc <= i_pc_data;
    if (i_sp_en)
        sp <= i_sp_data;
    if (i_i_en)
       i <= i_i_data;
end

assign o_pc_data = pc;
assign o_sp_data = sp;
assign o_i_rd = i;

endmodule
