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

           input		[3:0]	x,      // selects register Vx, where x points to the address
           input		[3:0]	y,      // selects register Vy, where y points to the address

           output	    [7:0]	Vx,
           output	    [7:0]	Vy,
           output	    [7:0]	Vf,


           input				wx,     // Vx write enable
           input		[7:0]	nx,     // new Vx data

           input				wf,     // Vf write enable
           input		[7:0]	nf      // new Vf data
       );

reg [7:0] Vreg [0:15];

assign Vx = Vreg[x];
assign Vy = Vreg[y];
assign Vf = Vreg[15];

always @ (posedge clk) begin
    if (wx)
        Vreg[x] <= nx;
    if (wf)
        Vreg[15] <= nf;
end

endmodule
