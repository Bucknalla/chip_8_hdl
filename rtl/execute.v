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

    input [5:0] i_decode, // the operation, I.e ADD, MOV
    input [7:0] i_byte_kk, //byte, 'kk' in the cowgod reference
    input [7:0] i_vx_data, //value inside register i_vx_data
    input [7:0] i_vy_data, //value inside register i_vy_data
    input [3:0] i_vx_addr, //adress of i_vx_data register - is this needed

    output reg [3:0] o_vx_addr //address of i_vx_addr register to write to
    output reg [7:0] o_vx_data, // new i_vx_data data
    output reg o_vf_data, // new Vf flag
    output reg o_vf_en, // write Vf flag
    output reg o_vx_en, //write to register address o_vx_addr enable

    input [11:0] i_mem_addr,// used to be called addr
    input [15:0] i_pc_data,
    input [7:0] i_sp_data,
    input [15:0] i_i_data,

    //memory interface
    output reg o_mem_w_en,
    output reg [7:0] o_mem_w_addr,
    output reg [15:0] o_mem_w_data,
    output o_mem_r_en,
    output [7:0] o_mem_r_addr,
    input [15:0] o_mem_r_data,


    output reg [15:0] o_pc_data,
    output reg o_pc_en,
    output reg [7:0] o_sp_data ,
    output reg o_sp_en,
    output reg [15:0] o_i_data,
    output reg o_i_en

    // wr???
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
  // localparam  LD_ST_VX = 6'd31;
  localparam  LD_F_VX = 6'd32;
  localparam  LD_B_VX = 6'd33;
  localparam  STORE_REG_VX = 6'd34;
  localparam  READ_REG_VX = 6'd35;

  localparam STACK_OFFSET = 16'd240;

  wire [8:0] add_vx_vy = i_vx_data + i_vy_data;
  wire sub_vx_vy_flag = i_vx_data < i_vy_data;
  wire sub_vy_vx_flag = i_vx_data > i_vy_data;
  //wire [8:0] add_val = i_vx_data + i_byte_kk;

  assign o_mem_r_addr = (i_decode == RET) ? (i_sp_data + STACK_OFFSET) : 0;
  assign o_mem_r_en = (i_decode == RET);
 ///////////////////
 //////////////////
 //ADD PC INCREMENT AND FETCH PULSE
  always@(posedge clk) begin
    o_sp_en <= 0;
    o_pc_en <= 0;
    o_i_en <= 0;
    wr_en <= 0;
    o_vx_en <= 0;
    o_vx_data <= 0;
    o_vf_en<= 0;
    case(i_decode)
      JMP:
        o_pc_data <= i_mem_addr;

      RET: begin
        //get stack
       o_pc_en <= 1;
       //retrieve pc value from top of stack
       o_pc_data <= o_mem_r_data;
       //decrement stack pointer
       o_sp_en <= 1;
       o_sp_data <= i_sp_data - 1;
      end

      CALL: begin
        o_sp_en <= 1;
        o_sp_data <= i_sp_data + 1;
        //change names for bram signal
        o_mem_w_addr <= STACK_OFFSET + i_sp_data;
        o_mem_w_data <= i_pc_data;
        o_mem_w_en <= 1;
        o_pc_data <= i_mem_addr;
        o_pc_en <= 1;
      end

      SE_VAL:
        if(i_vx_data == i_byte_kk) begin
          o_pc_data <= i_pc_data+1;
          o_pc_en <= 1;
        end

      SNE_VAL:
        if(i_vx_data != i_byte_kk) begin
          o_pc_data <= i_pc_data+1;
          o_pc_en <= 1;
        end

      SE_VX_VY:
        if(i_vx_data == i_vy_data) begin
          o_pc_data <= i_pc_data+1;
          o_pc_en <= 1;
        end

      LD_VX_VAL: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_byte_kk;
      end

      ADD_VX_VAL: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vx_data + i_byte_kk;
      end

      LD_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vy_data;
      end

      OR_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vx_data | i_vy_data;
      end

      AND_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vx_data & i_vy_data;
      end

      XOR_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vx_data ^ i_vy_data;
      end

      ADD_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= add_vx_vy[7:0];
        o_vf_en <= 1; //need to store carry in VF
        o_vf_data <= add_vx_vy[8];
      end

      SUB_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vx_data - i_vy_data;
        o_vf_en <= 1;
        o_vf_data <= i_vx_data < i_vy_data;
      end

      SHR_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vy_data >> 1;
        o_vf_en <= 1;
        o_vf_data <= i_vy_data[0];
      end

      SUBN_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vy_data - i_vx_data;
        o_vf_en <= 1;
        o_vf_data <= i_vy_data < i_vx_data;
      end

      SHL_VX_VY: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_vy_data << 1;
        o_vf_en <= 1;
        o_vf_data <= i_vy_data[7];
      end

      SNE_VX_VY: begin
        if(i_vx_data != i_vy_data) begin
          o_pc_data <= i_pc_data+1;
          o_pc_en <= 1;
        end
      end

      LD_I_ADDR: begin
        o_i_en <= 1;
        o_i_data <= {4'd0, i_mem_addr};
      end

      JMP_V0_ADDR: begin
        o_pc_en <= 1;
        o_pc_data <= i_mem_addr + i_vx_data; //i_vx_data in this case is v0
      end

      RAND_VX_VAL: begin
        o_vx_addr <= i_vx_addr;
        o_vx_en <= 1;
        o_vx_data <= i_byte_kk & rng;
      end


    endcase
  end

  reg [7:0] rng = 8'b01001010; //seed, make configrable
  always @(posedge clk)
   if (rst)
      rng <= {7{1'b0}};
   else begin
      rng <= {count[5:0],~(^(count &  8'b10110001))};
    end
  end

  endmodule
