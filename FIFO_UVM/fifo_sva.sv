module fifo_sva ();
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
	
    always_comb begin 
        //Reset
        if(!fifo_if.rst_n) begin
            assert_reset : assert final (FIFO.count == 0 && FIFO.wr_ptr == 0 && FIFO.rd_ptr == 0) ;
            cover_reset : cover final (FIFO.count == 0 && FIFO.wr_ptr == 0 && FIFO.rd_ptr == 0) ;
        end
        //FIFO_3
        if(FIFO.count == FIFO_DEPTH) begin
            assert_full : assert  (fifo_if.full) ;
            cover_full : cover  (fifo_if.full) ;
        end
        //FIFO_4
        if (FIFO.count == 0) begin
            assert_empty : assert  (fifo_if.empty) ;
            cover_empty : cover  (fifo_if.empty) ;
        end
        //FIFO_5
        if (FIFO.count == FIFO_DEPTH-1) begin // error in design, should be FIFO_DEPTH-1
            assert_almostfull : assert  (fifo_if.almostfull) ;
            cover_almostfull : cover  (fifo_if.almostfull) ;
        end
        //FIFO_6
        if (FIFO.count == 1) begin
            assert_almostempty : assert  (fifo_if.almostempty) ;
            cover_almostempty : cover  (fifo_if.almostempty) ;
        end
    end

    //FIFO_7
    property p_wr_ack;
        @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
        (fifo_if.wr_en && FIFO.count < FIFO_DEPTH) |=> (fifo_if.wr_ack);
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
        (fifo_if.wr_en && FIFO.wr_ptr == FIFO_DEPTH-1 && !fifo_if.full) ##1 (fifo_if.wr_en && !fifo_if.full ) |-> (FIFO.wr_ptr == 0);
    endproperty
    assert_wr_ptr_wrap_up: assert property (p_wr_ptr_wrap_up) ;
    cover_wr_ptr_wrap_up: cover property (p_wr_ptr_wrap_up) ;
    //FIFO_11
    property p_rd_ptr_wrap_up;
        @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
        (fifo_if.rd_en && FIFO.rd_ptr == FIFO_DEPTH-1 && !fifo_if.empty ) ##1 (fifo_if.rd_en && !fifo_if.empty) |-> (FIFO.rd_ptr == 0);
    endproperty
    assert_rd_ptr_wrap_up: assert property (p_rd_ptr_wrap_up) ;
    cover_rd_ptr_wrap_up: cover property (p_rd_ptr_wrap_up) ;
    //FIFO_12
    property p_count_up;
        @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
        ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10 && !fifo_if.full) |=> (FIFO.count == $past(FIFO.count) + 1'b1);
    endproperty
    assert_count_up: assert property (p_count_up) ;
    cover_count_up: cover property (p_count_up) ;
    //FIFO_13
    property p_count_down;
        @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) 
        ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01 && !fifo_if.empty) |=> (FIFO.count == $past(FIFO.count) - 1'b1);
    endproperty
    assert_count_down: assert property (p_count_down) ;
    cover_count_down: cover property (p_count_down) ;
    //FIFO_14
    property pointer_threshold;
        @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
        !(FIFO.wr_ptr >= FIFO_DEPTH) && !(FIFO.rd_ptr >= FIFO_DEPTH) && !(FIFO.count > FIFO_DEPTH);
    endproperty
    assert_pointer_threshold : assert property (pointer_threshold);
    cover_pointer_threshold  : cover  property (pointer_threshold);


endmodule