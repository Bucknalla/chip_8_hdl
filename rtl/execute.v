//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall & Ryan Cooke
//
// Create Date: 29/08/2018
// Design Name: execute.v
// Module Name: cpu
// Project Name: hdl_8_hdl
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
module execute(
    input clk,
    input rst,

    input [6:0] decode,
    input [7:0] val,
    input [7:0] vx,
    input [7:0] vy,
    input [3:0] x,
    input [3:0] y,

    input [11:0] addr,

    output [3:0] x_out,
    output [3:0] y_out,

    output reg [15:0] pc_out,
    output reg pc_inc,
    output reg sp_out
  );

  localparam DISP_CLR = 6'd1;
  localparam RET = 6'd2;
  localparam JMP = 6'd3;
  localparam CALL = 6'd4;
  localparam SE_VAL = 6'd5;
  localparam SNE_VAL = 6'd6;
  localparam SE_VX_VY = 6'd7;
  localparam LD_VX_VAL = 6'd8;
  localparam ADD_VX_VAL = 6'd9;
  localparam LD_VX_VY = 6'd10;
  localparam  OR_VX_VY = 6'd11;
  localparam  AND_VX_VY = 6'd12;
  localparam  XOR_VX_VY = 6'd13;
  localparam  ADD_VX_VY = 6'd14;
  localparam  SUB_VX_VY = 6'd15;
  localparam  SHR_VX_VY = 6'd16;
  localparam  SUBN_VX_VY = 6'd17;
  localparam  SHL_VX_VY = 6'd18;
  localparam  SNE_VX_VY = 6'd19;
  localparam  LD_I_ADDR = 6'd20;
  localparam  JMP_V0_ADDR = 6'd21;
  localparam  RAND_VX_VAL = 6'd22;
  localparam  DRW_VX_VY = 6'd23;
  localparam  SKP_VX = 6'd24;
  localparam  SKNP_VX = 6'd25;
  localparam  LD_VX_DT = 6'd26;
  localparam  LD_VX_K = 6'd27;
  localparam  LD_DT_VX = 6'd28;
  localparam  LD_ST_VX = 6'd29;
  localparam  ADD_I_VX = 6'd30;
  localparam  LD_ST_VX = 6'd31;
  localparam  LD_F_VX = 6'd32;
  localparam  LD_B_VX = 6'd33;
  localparam  STORE_REG_VX = 6'd34;
  localparam  READ_REG_VX = 6'd35;


  always@(posedge clk) begin
  sp_inc <= 0;
  pc_inc <= 0;
    case(decode)
      JMP:
