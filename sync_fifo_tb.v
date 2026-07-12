`timescale 1ns/1ps

module sync_fifo_tb;

parameter DATA_WIDTH = 8;
parameter DEPTH = 8;
parameter ADDR_WIDTH = 3;

reg clk;
reg rst;
reg wr_en;
reg rd_en;
reg [DATA_WIDTH-1:0] din;

wire [DATA_WIDTH-1:0] dout;
wire full;
wire empty;

sync_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

always #5 clk = ~clk;
initial begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 0;
    #10;
    rst = 0;
    @(posedge clk);
    wr_en = 1;
    din = 8'd10;

    @(posedge clk);
    din = 8'd20;

    @(posedge clk);
    din = 8'd30;

    @(posedge clk);
    wr_en = 0;

    rd_en = 1;
    @(posedge clk);

    @(posedge clk);

    rd_en = 0;

    wr_en = 1;
    rd_en = 1;
    din = 8'd40;
    @(posedge clk);

    wr_en = 0;
    rd_en = 0;

    repeat(8)
    begin
        @(posedge clk);
        wr_en = 1;
        din = din + 8'd10;
    end

    @(posedge clk);
    wr_en = 0;

    repeat(8)
    begin
        @(posedge clk);
        rd_en = 1;
    end

    @(posedge clk);
    rd_en = 0;

    #20;
    $finish;
end

initial begin
    $monitor("Time=%0t rst=%b wr=%b rd=%b din=%d dout=%d count? full=%b empty=%b",
             $time, rst, wr_en, rd_en, din, dout, full, empty);
end
initial begin
$dumpfile("sync_fifo_tb.vcd");
$dumpvars(0,sync_fifo_tb);
end
endmodule