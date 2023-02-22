`timescale 1ns/1ps

module PE_Array_1D_5_TB();

	parameter DATA_WIDTH = 16;
	localparam PERIOD = 100;

	reg clk;
	reg reset;
    reg [2:0] filter_size;
	reg [2:0] stride;
	reg [DATA_WIDTH-1:0] Current_A;
	reg [DATA_WIDTH-1:0] Current_B;
	reg [DATA_WIDTH-1:0] Current_B2;
    reg [DATA_WIDTH-1:0] Current_B3;
    reg [DATA_WIDTH-1:0] Current_B4;
    reg [DATA_WIDTH-1:0] Current_B5;
	wire [DATA_WIDTH-1:0] PE_Array_out;

    PE_Array_1D PE_Array_1D_inst(
        .clk(clk),
        .reset(reset),
        .filter_size(filter_size),
		.stride(stride),
        .Current_A(Current_A),
        .Current_B1(Current_B),
		.Current_B2(Current_B2),
		.Current_B3(Current_B3),
		.Current_B4(Current_B4),
		.Current_B5(Current_B5),
        .PE_Array_out(PE_Array_out)
    );

	task wait_clk;
		@(posedge clk);
		#(PERIOD/2);
	endtask

	always #(PERIOD/2) clk = ~clk;

	initial begin

		#0
		clk = 1'b0;
        filter_size = 5;
		stride = 1;
		reset = 0;
	//1
		// A = 1 , B = -2(MulResult = -2)
		Current_A = 16'h3C00;
		Current_B = 16'hC000;
		Current_B2 = 16'hC000;
		Current_B3 = 16'hC000;
        Current_B4 = 16'hC000;
        Current_B5 = 16'hC000;

		wait_clk;
		reset = 1;

		wait_clk;
		// A = 2 , B = -2(MulResult = -4)
		Current_A = 16'h4000;	

		wait_clk;
		// A = 3 , B = -2(MulResult = -6)
		Current_A = 16'h4200;

        wait_clk;
        // A = 4 , B = -2(MulResult = -8)
	    Current_A = 16'h4400;

        wait_clk;
        // A = 5 , B = -2(MulResult = -10)
	    Current_A = 16'h4500;

	//2
        wait_clk;
        // A = 6 , B = -2(MulResult = -12)
	    Current_A = 16'h4600;

        wait_clk;
        // A = 7 , B = -2(MulResult = -14)
	    Current_A = 16'h4700;

        wait_clk;
        // A = 8 , B = -2(MulResult = -16)
	    Current_A = 16'h4800;

        wait_clk;
        // A = 9 , B = -2(MulResult = -18)
	    Current_A = 16'h4880;

        wait_clk;
        // A = 10 , B = -2(MulResult = -20)
	    Current_A = 16'h4900;

	//3
		wait_clk;
		// A = 2 , B = -2(MulResult = -4)
		Current_A = 16'h4000;

		wait_clk;
		// A = 2 , B = -2(MulResult = -4)
		Current_A = 16'h4000;	

		wait_clk;
		// A = 3 , B = -2(MulResult = -6)
		Current_A = 16'h4200;

        wait_clk;
        // A = 4 , B = -2(MulResult = -8)
	    Current_A = 16'h4400;

        wait_clk;
        // A = 5 , B = -2(MulResult = -10)
	    Current_A = 16'h4500;

		#(PERIOD*6);
		wait_clk;
		$stop;	

	end

endmodule
