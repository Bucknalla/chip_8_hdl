module execute_tb();

  reg clk = 0;
  reg rst = 1;
  reg [6:0] test_decode = 0;
  reg [7:0] test_byte_kk = 0;
  reg [7:0] test_vx_data = 0;
  reg [7:0] test_vy_data = 0;
  reg [3:0] test_vx_addr = 0;
  reg [3:0] test_mem_addr = 0;
  reg [15:0] test_pc = 0;
  reg [7:0] test_sp = 0;

  always begin
    #1 clk = ~clk;
  end


  execute U1(
    .clk(clk),
    .rst(rst),
    .i_decode(test_decode),
    .i_byte_kk(test_byte_kk),
    .i_vx_data(test_vx_data),
    .i_vy_data(test_vy_data),
    .i_vx_addr(test_vx_addr), //adress of i_vx_data register - is this needed

    .o_vx_addr(), //address of i_vx_addr register to write to
    .o_vx_data(), // new i_vx_data data
    .o_vf_data(), // new Vf flag
    .o_vf_en(), // write Vf flag
    .o_vx_en(), //write to register address o_vx_addr enable

    .i_mem_addr(test_mem_addr),// used to be called addr
    .i_pc_data(test_pc),
    .i_sp_data(test_sp),
    .i_i_data(),

    //memory interface
    .o_mem_w_en(),
    .o_mem_w_addr(),
    .o_mem_w_data(),
    .o_mem_r_en(),
    .o_mem_r_addr(),
    .o_mem_r_data(),


    .o_pc_data(),
    .o_pc_en(),
    .o_sp_data(),
    .o_sp_en(),
    .o_i_data(),
    .o_i_en()
)


endmodule
