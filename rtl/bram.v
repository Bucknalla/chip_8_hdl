
module bram();

SB_RAM40_4K ram40_4kinst_physical (
    .RDATA(RDATA),
    .RADDR(RADDR),
    .WADDR(WADDR),
    .MASK(MASK),
    .WDATA(WDATA),
    .RCLKE(RCLKE),
    .RCLK(RCLK),
    .RE(RE),
    .WCLKE(WCLKE),
    .WCLK(WCLK),
    .WE(WE)
);

defparam ram40_4kinst_physical.READ_MODE=0;
defparam ram40_4kinst_physical.WRITE_MODE=0;

endmodule