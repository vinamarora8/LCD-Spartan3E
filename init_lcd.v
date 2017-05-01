//TODO
//// Write
//// Test

module init_lcd(clk, start, lcd_rs, lcd_rw, lcd_e, sf_d, ready);

// Assigning ports as in/out
input clk;
input start;

output lcd_rs;
output lcd_rw;
output lcd_e;
output [3:0] sf_d;
output ready;

// Instantiating and Initializing Registers
//// Control Registers
reg on_status;		// on_status flag. On - or - Off
reg op_status;		// Op_status flag. Power on init - or - Disp Config
reg [19:0] counter;

initial
begin
	on_status = 1'b0;
	op_status = 1'b0;
	counter = 0;
end

//// Power Up Sequence Registers
reg pu_lcd_rw;
reg pu_lcd_rs;
reg pu_lcd_e;
reg [3:0] pu_sf_d;

initial
begin
	pu_lcd_rw = 1'b1
	pu_lcd_rs = 1'b0;
	pu_lcd_e = 1'b0;
	pu_sf_d = 4'h0;
end

//// Display Config Registers/Wires
reg [9:0] command;
reg issue_command;
wire [3:0] dc_sf_d;
wire dc_lcd_rw;
wire dc_lcd_rs;
wire dc_lcd_e;
wire command_sender_ready;

initial
begin
	command = 0;
	issue_command = 1'b0;
end

// Wire Connections
assign ready = (counter == 0) & (~on_status) & (~op_status);
assign lcd_rs = (op_status) ? dc_lcd_rs : pu_lcd_rs;
assign lcd_rw = (op_status) ? dc_lcd_rw : pu_lcd_rw;
assign lcd_e = (op_status) ? dc_lcd_e : pu_lcd_e;
assign sf_d = (op_status) ? dc_sf_d : pu_sf_e;

command_sender command_sender_1(
	.clk(clk),
	.start(issue_command),
	.rs_in(command[9]),
	.rw_in(command[8]),
	.data_in(command[7:0]),
	.lcd_rs(dc_lcd_rs),
	.lcd_rw(dc_lcd_rw),
	.sf_d(dc_sf_d),
	.lcd_e(dc_lcd_e),
	.ready(command_sender_ready)
	);

// State machine
always @(posedge clk)
begin
	if (start)
		on_status = 1'b1;

	if (on_status)
	begin
		
		// Power-On Initialization
		if (~op_status)
		begin
			if (counter == 0)
			begin
				sf_d = 4'h0;
				lcd_e = 1'b0;
				lcd_rs = 1'b0;
				lcd_rw = 1'b0;
			end
			if (counter == 750000)
			begin
				sf_d = 4'h3;
				lcd_e = 1'b1;
			end
			if (counter == 750015)
			begin
				sf_d = 4'h0;
				lcd_e = 1'b0;
			end
			if (counter == 955100)
			begin
				sf_d = 4'h3;
				lcd_e = 1'b1;
			end
			if (counter == 955115)
			begin
				sf_d = 4'h0;
				lcd_e = 1'b0;
			end
			if (counter == 960200)
			begin
				sf_d = 4'h3;
				lcd_e = 1'b1;
			end
			if (counter == 960215)
			begin
				sf_d = 4'h0;
				lcd_e = 1'b0;
			end
			if (counter == 962300)
			begin
				sf_d = 4'h2;
				lcd_e = 1'b1;
			end
			if (counter == 962315)
			begin
				sf_d = 4'h0;
				lcd_e = 1'b0;
			end
			if (counter == 964500)
			begin
				counter = 0;
				op_status = 1'b1;
			end
			else
			begin
				counter = counter + 1;
			end

			if (op_status)
			begin
				
			end
		end
	
		// Display Configuration

	end
end