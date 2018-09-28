module counter (input clock,reset,load,updown, input [3:0]load_data, output reg [3:0]count);

always@(negedge clock)
	begin
		if(reset)
			count<=4'b0;
		else if (load)
			count<=load_data;
		else
			begin
				 if (updown)
					count<=count+1'b1;
				else 
					count<=count-1'b1;
			end
	end
endmodule
