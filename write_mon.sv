//Write monitor for counter.
class counter_write_mon;

	virtual counter_if.WR_MON wrmon_if;

	counter_trans data2rm;

	mailbox #(counter_trans) mon2rm;
	
	function new(virtual counter_if.WR_MON wrmon_if,
			mailbox #(counter_trans) mon2rm
			);
		this.wrmon_if=wrmon_if;
		this.mon2rm=mon2rm;
		this.data2rm=new;
	endfunction: new


	task monitor();
		begin
			data2rm.reset= wrmon_if.wr_mon_cb.reset;
			data2rm.updown =  wrmon_if.wr_mon_cb.updown;
			data2rm.load= wrmon_if.wr_mon_cb.load;
			data2rm.load_data= wrmon_if.wr_mon_cb.load_data;
			data2rm.display("DATA FROM WRITE MONITOR");
		end
	endtask
	
	
//In start task
			
	task start();
		fork
		forever
			begin
			monitor(); 
			mon2rm.put(data2rm);
			end
		join_none
	endtask: start

endclass:counter_write_mon
