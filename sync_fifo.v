module sync_fifo#(parameter DATA_WIDTH=8, parameter DEPTH=8,parameter ADDR_WIDTH=$clog2(DEPTH))(input clk,input rst, input wr_en, input rd_en, input [DATA_WIDTH-1:0]din, output reg [DATA_WIDTH-1:0]dout,output full, output empty);
reg[DATA_WIDTH-1:0] mem[0:DEPTH-1];
reg [ADDR_WIDTH-1:0]wr_ptr;
reg [ADDR_WIDTH-1:0]rd_ptr;
reg [ADDR_WIDTH:0]count;
assign full=(count==DEPTH);
assign empty=(count==0);
always @(posedge clk)
begin
if(rst)
begin
count<=0;
wr_ptr<=0;
rd_ptr<=0;
dout<=0;
end
else
begin
case({wr_en,rd_en})
2'b10:begin
if(!full)
begin
mem[wr_ptr]<=din;
wr_ptr<=wr_ptr+1;
count<=count+1;
end
end
2'b01:begin
if(!empty)
begin
dout<=mem[rd_ptr];
rd_ptr<=rd_ptr+1;
count<=count-1;
end
end
2'b11:begin
if(!full && !empty)
begin
mem[wr_ptr]<=din;
dout<=mem[rd_ptr];
rd_ptr<=rd_ptr+1;
wr_ptr<=wr_ptr+1;
end
else if(empty)
begin
mem[wr_ptr]<=din;
count<=count+1;
wr_ptr<=wr_ptr+1;
end
else if(full)
begin
rd_ptr<=rd_ptr+1;
dout<=mem[rd_ptr];
count<=count-1;
end
end
default:begin
end
endcase
end
end
endmodule