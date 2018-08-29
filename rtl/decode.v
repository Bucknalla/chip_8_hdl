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

localparam DISP_CLR = 5'h1;
localparam RET = 5'h2;
localparam JMP = 5'h3;
localparam CALL = 5'h4;
localparam SE_VAL = 5'h5;
localparam SNE_VAL = 5'h6;
localparam SE_VX_VY = 5'h7;
localparam LD_VX_VAL = 5'h8;
localparam ADD_VX_VAL = 5'h9;
localparam LD_VX_VY = 5'h10;
localparam  OR_VX_VY = 5'h11;
localparam  AND_VX_VY = 5'h12;
localparam  XOR_VX_VY = 5'h13;
localparam  ADD_VX_VY = 5'h14;
localparam  SUB_VX_VY = 5'h15;
localparam  SHR_VX_VY = 5'h16;
localparam  SUBN_VX_VY = 5'h17;
localparam  SHL_VX_VY = 5'h18;
localparam  SNE_VX_VY = 5'h19;

//instructions stored with most significat byt
always@(posedge clk) begin
  decode <= 5'h0;
  case(instruction[15:12]) 
    4'h0: begin
      //zero instructions -
      //display clear
      //return from subroutine
      if(instruction[3:0] == 4'h0)
      begin
        decode <= DISP_CLR;
      end else if(instruction[3:0] == 4'hE)
      begin
        decode <= RET;
      end
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



  endcase
end




endmodule
