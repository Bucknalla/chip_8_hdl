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

  output reg [4:0] decode,


  output reg [15:0] addr_out,
  output reg [3:0] x,
  output reg [3:0] y,
  output reg [7:0] val

       );

localparam DISP_CLR = 5'd1;
localparam RET = 5'd2;
localparam JMP = 5'd3;
localparam CALL = 5'd4;
localparam SE_VAL = 5'd5;
localparam SNE_VAL = 5'd6;
localparam SE_VX_VY = 5'd7;
localparam LD_VX_VAL = 5'd8;
localparam ADD_VX_VAL = 5'd9;
localparam LD_VX_VY = 5'd10;
localparam  OR_VX_VY = 5'd11;
localparam  AND_VX_VY = 5'd12;
localparam  XOR_VX_VY = 5'd13;
localparam  ADD_VX_VY = 5'd14;
localparam  SUB_VX_VY = 5'd15;
localparam  SHR_VX_VY = 5'd16;
localparam  SUBN_VX_VY = 5'd17;
localparam  SHL_VX_VY = 5'd18;
localparam  SNE_VX_VY = 5'd19;

//instructions stored with most significat byt
always@(posedge clk) begin
  decode <= 5'd0;
  case(instruction[15:12]) begin
    4'd0: begin
      //zero instructions -
      //display clear
      //return from subroutine
      if(instruction[3:0] == 4'h0)begin
        decode <= DISP_CLR;
      end else if(instruction[3:0] == 4'hE)
        decode <= RET;
      end
    end

    4'd1: begin
      decode <= JMP;
      addr_out <= instruction[11:0];
    end

    4'd2: begin
      decode <= CALL;
      addr_out <= instruction[11:0];
    end

    4'd3: begin
      decode <= SE_VAL;
      x <= instruction[11:8];
      val <= instruction[7:0];
    end

    4'd4: begin
      decode <= SNE_VAL;
      x <= instruction[11:8];
      val <= instruction[7:0];
    end

    4'd5: begin
      decode <= SE_VX_VY;
      x <= instruction[11:8];
      y <= instruction[7:4];
    end

    4'd6: begin
      decode <= LD_VX_VAL;
      val <= instruction[7:0];
      x <= instruction[11:8];
    end

    4'd7: begin
      decode <= ADD_VX_VAL;
      val <= instruction[7:0];
      x <= instruction[11:8];
    end

    4'd8: begin
      case(instruction[3:0]) begin
        4'd0: begin
          decode <= LD_VX_VY;
          val <= instruction[7:0];
          x <= instruction[11:8];
        end
        4'd1: begin
          decode <= OR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd2: begin
          decode <= AND_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd3: begin
          decode <= XOR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd4: begin
          decode <= ADD_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd5: begin
          decode <= SUB_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd6: begin
          decode <= SHR_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'd7: begin
          decode <= SUBN_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
        4'dE: begin
          decode <= SHL_VX_VY;
          y <= instruction[7:4];
          x <= instruction[11:8];
        end
      endcase
    end

    4'd9: begin
      decode <= SNE_VX_VY;
      y <= instruction[7:4];
      x <= instruction[11:8];
    end

    4'd10: begin
      decode <= LD_I_ADDR;
      addr_out <= instruction[11:0];
    end

    4'd11: begin
      decode <= JUMP_V0_ADDR;
      addr_out <= instruction[11:0];
    end

    4'd12: begin
      decode <= RAND_VX_VAL;
      addr_out <= instruction[11:0];
    end



  endcase
end




endmodule
