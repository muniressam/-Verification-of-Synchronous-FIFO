////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT fifo_if);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	//input [FIFO_WIDTH-1:0] data_in;
	//input clk, rst_n, wr_en, rd_en;
	//output reg [FIFO_WIDTH-1:0] data_out;
	//output reg wr_ack, overflow;
	//output full, empty, almostfull, almostempty, underflow;
	 
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);
	
	reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
	
	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;
	
	
	`ifdef SIM
		always_comb begin 
			//Reset
			if(!fifo_if.rst_n) begin
				assert_reset : assert final (count == 0 && wr_ptr == 0 && rd_ptr == 0) ;
				cover_reset : cover final (count == 0 && wr_ptr == 0 && rd_ptr == 0) ;
			end
			//FIFO_3
			if(count == FIFO_DEPTH) begin
				assert_full : assert  (fifo_if.full) ;
				cover_full : cover  (fifo_if.full) ;
			end
			//FIFO_4
			if (count == 0) begin
				assert_empty : assert  (fifo_if.empty) ;
				cover_empty : cover  (fifo_if.empty) ;
			end
			//FIFO_5
			if (count == FIFO_DEPTH-1) begin // error in design, should be FIFO_DEPTH-1
				assert_almostfull : assert  (fifo_if.almostfull) ;
				cover_almostfull : cover  (fifo_if.almostfull) ;
			end
			//FIFO_6
			if (count == 1) begin
				assert_almostempty : assert  (fifo_if.almostempty) ;
				cover_almostempty : cover  (fifo_if.almostempty) ;
			end
		end
	`endif
	
	
	`ifdef SIM
		//FIFO_7
		property p_wr_ack;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			(fifo_if.wr_en && count < FIFO_DEPTH) |=> (fifo_if.wr_ack);
		endproperty
		assert_wr_ack: assert property (p_wr_ack) ;
		cover_wr_ack: cover property (p_wr_ack)  ;
		//FIFO_8
		property p_overflow;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			(fifo_if.full && fifo_if.wr_en) |=> (fifo_if.overflow);
		endproperty
		assert_overflow: assert property (p_overflow) ;
		cover_overflow: cover property (p_overflow) ;
		//FIFO_9
		property p_underflow;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			(fifo_if.empty && fifo_if.rd_en) |=> (fifo_if.underflow);
		endproperty
		assert_underflow: assert property (p_underflow) ;
		cover_underflow: cover property (p_underflow) ;
		//FIFO_10
		property p_wr_ptr_wrap_up;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			(fifo_if.wr_en && wr_ptr == FIFO_DEPTH-1 && !fifo_if.full) ##1 (fifo_if.wr_en && !fifo_if.full ) |-> (wr_ptr == 0);
		endproperty
		assert_wr_ptr_wrap_up: assert property (p_wr_ptr_wrap_up) ;
		cover_wr_ptr_wrap_up: cover property (p_wr_ptr_wrap_up) ;
		//FIFO_11
		property p_rd_ptr_wrap_up;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			(fifo_if.rd_en && rd_ptr == FIFO_DEPTH-1 && !fifo_if.empty ) ##1 (fifo_if.rd_en && !fifo_if.empty) |-> (rd_ptr == 0);
		endproperty
		assert_rd_ptr_wrap_up: assert property (p_rd_ptr_wrap_up) ;
		cover_rd_ptr_wrap_up: cover property (p_rd_ptr_wrap_up) ;
		//FIFO_12
		property p_count_up;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			({fifo_if.wr_en, fifo_if.rd_en} == 2'b10 && !fifo_if.full) |=> (count == $past(count) + 1'b1);
		endproperty
		assert_count_up: assert property (p_count_up) ;
		cover_count_up: cover property (p_count_up) ;
		//FIFO_13
		property p_count_down;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
			({fifo_if.wr_en, fifo_if.rd_en} == 2'b01 && !fifo_if.empty) |=> (count == $past(count) - 1'b1);
		endproperty
		assert_count_down: assert property (p_count_down) ;
		cover_count_down: cover property (p_count_down) ;
		//FIFO_14
		property pointer_threshold;
			@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
			!(wr_ptr >= FIFO_DEPTH) && !(rd_ptr >= FIFO_DEPTH) && !(count > FIFO_DEPTH);
		endproperty
		assert_pointer_threshold : assert property (pointer_threshold);
		cover_pointer_threshold  : cover  property (pointer_threshold);
	
	`endif
	
	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			wr_ptr <= 0;
			fifo_if.wr_ack <=0; // bugs
			fifo_if.overflow <= 0;//bugs
		end
		else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
			mem[wr_ptr] <= fifo_if.data_in;
			fifo_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			fifo_if.overflow <=0; //bugs
		end
		else begin 
			fifo_if.wr_ack <= 0; 
			if (fifo_if.full && fifo_if.wr_en) //bugs &&
				fifo_if.overflow <= 1;
			else
				fifo_if.overflow <= 0;
		end
	end
	
	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			rd_ptr <= 0;
			fifo_if.underflow <= 0; // bugs
		
		end
		else if (fifo_if.rd_en && count != 0) begin
			fifo_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			fifo_if.underflow <= 0; // bugs
		end
		else begin
			if (fifo_if.empty && fifo_if.rd_en) // bugs &&
				fifo_if.underflow <= 1;
			else
				fifo_if.underflow <= 0;
		end
	end
	
	always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
		if (!fifo_if.rst_n) begin
			count <= 0;
		end
		else begin
			if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
				count <= count + 1;
			else if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty) 
				count <= count - 1;
			else if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty) 
				count <= count+1;
			else if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)
				count <= count-1;
			else 
				count <= count;

		end
	end
	
		assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
		assign fifo_if.empty = (count == 0)? 1 : 0;
		//fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; // sequential output
		assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // error in design, should be FIFO_DEPTH-1
		assign fifo_if.almostempty = (count == 1)? 1 : 0;
	
	endmodule