module alarm(clk50,led,reset,seg7,anode);

input clk50;
input reset;
output [6:0] seg7;
output [3:0] anode;
output led; 

wire intclk,led;

reg[3:0] dig1,dig2,dig3,dig4=4'b000;
reg[3:0] anode;
reg[3:0] hex;
//division of the clock for 7segment;
divclk segclk(.clk50(clk50),.intclk(intclk),.led(led));
//division of the clock for alarm
divclk2 secclk2(.clk50(clk50),.intclk(secclk));
// the 7 segment display
seg7display segdecoder(.ssOut(seg7),.nIn(hex));

//the clock
reg[7:0] min,sec=8'b00000000;
always @(posedge secclk)

begin
	sec=sec+1;
if (reset==1'b1) begin	
	sec=0;
	min=0;
end	
else begin
	if (sec==59) begin
		sec=0;
		min=min+1;
	end
	else if (min==59) begin
		min=0;
	end
	else begin
		sec=sec;
		min=min;
	end
end
	
dig1<=sec[3:0];
dig2<=sec[7:4];
dig3<=min[3:0];
dig4<=min[7:4];

end 



integer c=0;
always @(posedge intclk)
begin
	if (c==3)
		c=0;
	else
		c=c+1;
	
	begin
		case(c)
			0: begin anode<=4'b1110;
						hex<=dig1; end 
			1: begin anode<=4'b1101;
						hex<=dig2; end
			2: begin anode<=4'b1011;
						hex<=dig3; end
			3:	begin anode<=4'b0111;
						hex<=dig4; end 
		endcase
	end
end
endmodule
