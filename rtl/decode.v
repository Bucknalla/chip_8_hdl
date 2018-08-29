//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall & Ryan Cooke
//
// Create Date: 03/07/2018
// Design Name: decode.v
// Module Name: decode
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

module decode(
  input clk,
  input rst,

  input [15:0] instruction,

  output reg [5:0] decode,


  output reg [15:0] addr_out,
  output reg [3:0] x,
  output reg [3:0] y,
  output reg [3:0] nib,
  output reg [7:0] val

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
localparam  LD_F_VX = 6'd32;
localparam  LD_B_VX = 6'd33;
localparam  STORE_REG_VX = 6'd34;
localparam  READ_REG_VX = 6'd35;

//instructions stored with most significat byt
always@(posedge clk) begin
  decode <= 6'd0;
  x <= 4'd0;
  y <= 4'd0;
  val = 8'd0;
  nib <= 4'd0;
  addr_out = 12'd0;
  case(instruction[15:12])
    4'h0: begin
      if(instruction[3:0] == 4'h0)
        decode <= DISP_CLR;
      else if(instruction[3:0] == 4'hE)
        decode <= RET;
      else
        decode <= 0;
    end

    4'h1: begin
      decode <= JMP;
      addr_out <= instruction[11:0];
    end

    4'h2: begin
      decode <= CALL;
      addr_out <= instruction[11:0];
    end

    4'h3: begin
      decode <= SE_VAL;
      x <= instruction[11:8];
      val <= instruction[7:0];
    end

    4'h4: begin
      decode <= SNE_VAL;
      x <= instruction[11:8];
      val <= instruction[7:0];
    end

    4'h5: begin
      decode <= SE_VX_VY;
      x <= instruction[11:8];
      y <= instruction[7:4];
    end

    4'h6: begin
      decode <= LD_VX_VAL;
      val <= instruction[7:0];
      x <= instruction[11:8];
    end

    4'h7: begin
      decode <= ADD_VX_VAL;
      val <= instruction[7:0];
      x <= instruction[11:8];
    end

    4'h8: begin
      case(instruction[3:0])
        4'h0: begin
          decode <= LD_VX_VY;
          val <= instruction[7:0];
          x <= instruction[11:8];
        end
        4'h1: begin
          decode <= OR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h2: begin
          decode <= AND_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h3: begin
          decode <= XOR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h4: begin
          decode <= ADD_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h5: begin
          decode <= SUB_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h6: begin
          decode <= SHR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'h7: begin
          decode <= SUBN_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'hE: begin
          decode <= SHL_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
      endcase
    end

    4'h9: begin
      decode <= SNE_VX_VY;
      y <= instruction[7:4];
      x <= instruction[11:8];
    end

    4'hA: begin
      decode <= LD_I_ADDR;
      addr_out <= instruction[11:0];
    end

    4'hB: begin
      decode <= JUMP_V0_ADDR;
      addr_out <= instruction[11:0];
    end

    4'hC: begin
      decode <= RAND_VX_VAL;
      addr_out <= instruction[11:0];
    end

    4'hD: begin
      decode <= DRW_VX_VY;
      x <= instruction[11:8];
      y <= instruction[7:4];
      nib <= instruction[3:0];
    end

    4'hE: begin
      x <= instruction[11:8];
      if(instruction[7:0] == 8'h9E) begin
        decode <= SKP_VX;
      end else if(instruction[7:0] == 8'hA1) begin
        decode <= SKNP_VX;
      end else begin
        decode <= 0;
      end
    end

    4'hF: begin
      x <= instruction[11:8];
      case(instruction[7:0])
        8'h07:
          decode <= LD_VX_DT;
        8'h0A:
          decode <= LD_VX_K;
        8'h15:
          decode <= LD_DT_VX;
        8'h18:
          decode <= LD_ST_VX;
        8'h1E:
          decode <= ADD_I_VX;
        8'h29:
          decode <= LD_F_VX;
        8'h33:
          decode <= LD_B_VX;
        8'h55:
          decode <= STORE_REG_VX;
        8'h65:
          decode <= READ_REG_VX;
        default:
          decode <= 0;
      endcase
    end
  endcase
end


endmodule
