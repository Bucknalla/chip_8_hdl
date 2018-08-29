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

    input [5:0] decode,
    input [7:0] val,
    input [7:0] vx,
    input [7:0] vy,
    input [3:0] x,

    output reg [3:0] x_out,
    output reg wx, //vx write enable
    output reg [7:0] nx, // new vx data
    output reg wf,
    output reg [7:0] wx,

    input [11:0] addr,
    input [15:0] pc_rd,
    input [7:0] sp_rd,
    input [15:0] i_rd,

    output w_en,
    output [7:0] w_addr,
    output [15:0] w_data,
    output r_en,
    output [7:0] r_addr,
    input [15:0] r_data,


    output reg [15:0] pc_wr,
    output reg pc_en,
    output reg [7:0] sp_wr,
    output reg sp_en,
    output reg [15:0] i_wr,
    output reg i_en
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

  localparam STACK_OFFSET = 16'd240;

  wire [8:0] add_vx_vy = vx + vy;
  wire sub_vx_vy_flag = vx < vy;
  wire sub_vy_vx_flag = vx > vy;
  //wire [8:0] add_val = vx + val;

  assign r_addr = (decode == RET) ? (sp_rd + STACK_OFFSET) : 0;
  assign r_en = (decode == RET);
 ///////////////////
 //////////////////
 //ADD PC INCREMENT AND FETCH PULSE
  always@(posedge clk) begin
    sp_en <= 0;
    pc_en <= 0;
    i_en <= 0;
    wr_en <= 0;
    wx <= 0;
    nx <= 0;
    wf<= 0;
    wx <= 0;
    case(decode)
      JMP:
        pc_wr <= addr;

      RET: begin
        //get stack
       pc_en <= 1;
       //retrieve pc value from top of stack
       pc_wr <= r_data;
       //decrement stack pointer
       sp_en <= 1;
       sp_wr <= sp_rd - 1;

      CALL: begin
        sp_en <= 1;
        sp_wr <= sp_rd + 1;
        //change names for bram signal
        w_addr <= STACK_OFFSET + sp_rd;
        w_data <= pc_rd;
        w_en <= 1;
        pc_wr <= addr;
        pc_en <= 1;
      end

      SE_VAL:
        if(vx == val) begin
          pc_wr <= pc_rd+1;
          pc_en <= 1;
        end

      SNE_VAL:
        if(vx != val) begin
          pc_wr <= pc_rd+1;
          pc_en <= 1;
        end

      SE_VX_VY:
        if(vx == vy) begin
          pc_wr <= pc_rd+1;
          pc_en <= 1;
        end

      LD_VX_VAL: begin
        x_out <= x;
        wx <= 1;
        nx <= val;
      end

      ADD_VX_VAL: begin
        x_out <= x;
        wx <= 1;
        nx <= vx + val;
      end

      LD_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vy;
      end

      OR_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vx | vy;
      end

      AND_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vx & vy;
      end

      XOR_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vx ^ vy;
      end

      ADD_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= add_vx_vy[7:0];
        //need to store carry in VF
        wf <= 1;
        nf <= add_vx_vy[8];
      end

      SUB_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vx - vy;
        wf <= 1;
        nf <= sub_vx_vy_flag;
      end

      SHR_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vy >> 1;
        wf <= 1;
        nf <= vy[0];
      end

      SUBN_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vy - vx;
        wf <= 1;
        nf <= sub_vy_vx_flag;
      end

      SHL_VX_VY: begin
        x_out <= x;
        wx <= 1;
        nx <= vy << 1;
        wf <= 1;
        nf <= vy[7];
      end

      SNE_VX_VY: begin
        if(vx != vy) begin
          pc_wr <= pc_rd+1;
          pc_en <= 1;
        end
      end

      LD_I_ADDR: begin
        i_en <= 1;
        i_wr <= {4'd0, addr};
      end

      JMP_V0_ADDR: begin
        pc_en <= 1;
        pc_wr <= addr + vx; //vx in this case is v0
      end

      RAND_VX_VAL: begin
        x_out <= x;
        wx <= 1;
        nx <= val & rng;
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
