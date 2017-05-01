module command_sender(clk, start, rs_in, rw_in, data_in, lcd_rs, sf_d, lcd_rw, lcd_e, ready);

parameter t1 = 5;
parameter t2 = 20;
parameter t3 = 50;
parameter t4 = 25;
parameter t5 = 3000;

// Assigning ports as input/output
input clk;
input start;
input rs_in;
input rw_in;
input [7:0] data_in;

output reg lcd_rs;
output reg [3:0] sf_d;
output reg lcd_rw;
output reg lcd_e;
output ready;

// Instantiating and Initializing Registers
reg [11:0] counter;
initial counter = 0;

reg status;
initial status = 1'b0;

initial
begin
	lcd_rs = 1'b0;
	lcd_rw = 1'b0;
	sf_d = 4'h0;
	lcd_e = 1'b0;
end

// Assigning output wires
assign ready = (counter == 0 & status == 1'b0);

// State Machine
always @(posedge clk)
begin
	// Handling status flag
	if (start)
		status = 1'b1;
	
	// Handling output
	if (status)
	begin
		if (counter == 0)
		begin
			lcd_rs = rs_in;
			sf_d = data_in[7:4];
			lcd_rw = rw_in;
		end
		if (counter == t1)
		begin
			lcd_e = 1'b1;
		end
		if (counter == (t1+t2))
		begin
			lcd_e = 1'b0;
			sf_d = data_in[3:0];
		end
		if (counter == (t1+t2+t3))
		begin
			lcd_e = 1'b1;
		end
		if (counter == (t1+t2+t3+t4))
		begin
			lcd_e = 1'b0;
			lcd_rs = 1'b0;
			lcd_rw = 1'b0;
			sf_d = 4'h0;
			lcd_e = 1'b0;
		end
		if (counter == (t1+t2+t3+t4+t5))
		begin
			counter = 0;
			status = 1'b0;
		end
		else
		begin
			counter = counter + 1;
		end
	end
end

endmodule
