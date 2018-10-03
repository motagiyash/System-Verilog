class counter_env;


 
	virtual counter_if.WR_BFM wr_if;
	virtual counter_if.WR_MON wrmon_if;
	virtual counter_if.RD_MON rdmon_if;




	mailbox #(counter_trans) gen2wr=new();
	mailbox #(counter_trans) wr2rm=new();
	mailbox #(counter_trans) rd2sb=new();
	mailbox #(counter_trans) rm2sb=new();
	
	counter_gen gen;
	counter_write_bfm wr_bfm;
	counter_write_mon wr_mon;
	counter_read_mon rd_mon;
	counter_model model;
	counter_sb sb;


	function new(	virtual counter_if.WR_BFM wr_if,
			virtual counter_if.WR_MON wrmon_if,
			virtual counter_if.RD_MON rdmon_if);
		this.wr_if = wr_if;
		this.wrmon_if = wrmon_if;
		this.rdmon_if = rdmon_if;
	endfunction : new

	task build;
		gen = new(gen2wr);
		wr_bfm = new(wr_if,gen2wr);
		wr_mon = new(wrmon_if,wr2rm);
		rd_mon = new(rdmon_if,rd2sb);
		model= new(wr2rm,rm2sb);
		sb= new(rm2sb,rd2sb);
	endtask : build




	begin
		rd_if.rd_cb.rd_address<='0;
		rd_if.rd_cb.read<='0;

		wr_if.wr_cb.wr_address<=0;
		wr_if.wr_cb.write<='0;

		repeat(5) @(wr_if.wr_cb);
		for (int i=0; i<4096; i++)
		begin
			wr_if.wr_cb.write<='1;
			wr_if.wr_cb.wr_address<=i;
			wr_if.wr_cb.data_in<='0;
		@(wr_if.wr_cb);
		end
		wr_if.wr_cb.write<='0;
		repeat (5) @(wr_if.wr_cb);
	end
	endtask : reset_dut

	 task start;
		gen.start();
		wr_bfm.start();
		wr_mon.start();
		rd_mon.start();
		model.start();
		sb.start();
	endtask : start

	task stop();
		wait(sb.DONE.triggered);
	endtask : stop 



	task run();
		//reset_dut();
	  	start();
		stop();
		sb.report();
	endtask : run

endclass : counter_env
