// ----------------------------------------------------------------------------------
// -- Function : This module is a one-dimensional systolic array(Support up to 5 PEs)
// -- Designer : LXH
// ----------------------------------------------------------------------------------
module PE_Array_1D(
    clk,
    reset,
    filter_size,
    stride,
    Current_A,
    Current_B1,
    Current_B2,
    Current_B3,
    Current_B4,
    Current_B5,
    PE_Array_out
);

    parameter DATA_WIDTH = 16;

    input clk;
    input reset;
    input [2:0] filter_size;
    input [2:0] stride;
    input [DATA_WIDTH-1:0] Current_A;
    input [DATA_WIDTH-1:0] Current_B1;
    input [DATA_WIDTH-1:0] Current_B2;
    input [DATA_WIDTH-1:0] Current_B3;
    input [DATA_WIDTH-1:0] Current_B4;
    input [DATA_WIDTH-1:0] Current_B5;      
    output reg [DATA_WIDTH-1:0] PE_Array_out;

    wire [DATA_WIDTH-1:0] Next_A1;
    wire [DATA_WIDTH-1:0] Next_A2;
    wire [DATA_WIDTH-1:0] Next_A3;
    wire [DATA_WIDTH-1:0] Next_A4;
    wire [DATA_WIDTH-1:0] Next_A5;

    wire [DATA_WIDTH-1:0] PE_out1;
    wire [DATA_WIDTH-1:0] PE_out2;
    wire [DATA_WIDTH-1:0] PE_out3;
    wire [DATA_WIDTH-1:0] PE_out4;
    wire [DATA_WIDTH-1:0] PE_out5;

    wire [DATA_WIDTH-1:0] sum1;
    wire [DATA_WIDTH-1:0] sum2;
    wire [DATA_WIDTH-1:0] sum3;
    wire [DATA_WIDTH-1:0] sum4;

    reg done;
    reg [2:0] counter;

    ProcessingElement PE1(
        .clk(clk),
        .reset(reset),
        .Current_A(Current_A),
        .Current_B(Current_B5),
        .Next_A(Next_A1),
        .PE_out(PE_out1)
    );

    ProcessingElement PE2(
        .clk(clk),
        .reset(reset),
        .Current_A(Next_A1),
        .Current_B(Current_B4),
        .Next_A(Next_A2),
        .PE_out(PE_out2)
    );

    ProcessingElement PE3(
        .clk(clk),
        .reset(reset),
        .Current_A(Next_A2),
        .Current_B(Current_B3),
        .Next_A(Next_A3),
        .PE_out(PE_out3)
    );

    ProcessingElement PE4(
        .clk(clk),
        .reset(reset),
        .Current_A(Next_A3),
        .Current_B(Current_B2),
        .Next_A(Next_A4),
        .PE_out(PE_out4)
    );

    ProcessingElement PE5(
        .clk(clk),
        .reset(reset),
        .Current_A(Next_A4),
        .Current_B(Current_B1),
        .Next_A(Next_A5),
        .PE_out(PE_out5)
    );

    Float16Add Add1(
        .floatA(PE_out5),
        .floatB(PE_out4),
        .sum(sum1)
    );

    Float16Add Add2(
        .floatA(sum1),
        .floatB(PE_out3),
        .sum(sum2)
    );

    Float16Add Add3(
        .floatA(sum2),
        .floatB(PE_out2),
        .sum(sum3)
    );  

    Float16Add Add4(
        .floatA(sum3),
        .floatB(PE_out1),
        .sum(sum4)
    );

    always@ (posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= -1;
            done <= 0;
        end
        else begin
            if (counter == 4) begin
                counter <= 5-stride;
                done <= 1;
            end
            else begin
                counter <= counter + 1'b1;
                done <= 0;
            end
        end
     
    end

    always@ (posedge clk or negedge reset) begin
        if(!reset) begin
            PE_Array_out <= 0;
        end
        else begin
            if(filter_size == 1 && done == 1)
                PE_Array_out <= PE_out5;
            else if(filter_size == 2 && done == 1)
                PE_Array_out <= sum1;
            else if(filter_size == 3 && done == 1)
                PE_Array_out <= sum2;
            else if(filter_size == 4 && done == 1)
                PE_Array_out <= sum3;
            else if(filter_size == 5 && done == 1)
                PE_Array_out <= sum4;
        end
    end

endmodule