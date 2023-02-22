`timescale 1ns/1ps

module ProcessingElement_TB();

	parameter DATA_WIDTH = 16;
	localparam PERIOD = 100;

	reg clk;
	reg reset;
	reg [DATA_WIDTH-1:0] Current_A;
	reg [DATA_WIDTH-1:0] Current_B;
	wire [DATA_WIDTH-1:0] Next_A;
	wire [DATA_WIDTH-1:0] PE_out;

	ProcessingElement PE 
	(
		.clk(clk),
		.reset(reset),
		.Current_A(Current_A),
		.Current_B(Current_B),
		.Next_A(Next_A),
		.PE_out(PE_out)
	);

	task wait_clk;
		@(posedge clk);
		#(PERIOD/2);
	endtask

	always #(PERIOD/2) clk = ~clk;

	initial begin

		#0
		clk = 1'b0;
		reset = 0;
		// A = 2 , B = 3(MulResult = 6,16'h4600)
		Current_A = 16'h4000;
		Current_B = 16'h4200;

		wait_clk;
		reset = 1;

		wait_clk;
		// A = 5.6 , B = 3(MulResult = 16.8,16'h4c33)
		Current_A = 16'h459a;	

		wait_clk;
		// A = -8.8 , B = 3(MulResult = -26.4,16'hce9a)
		Current_A = 16'hc866;

		#(PERIOD*6);
		wait_clk;
		$stop;	

	end

endmodule
