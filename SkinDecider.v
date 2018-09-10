module SkinDecider(luma_ch, cb_ch, cr_ch,
		   object_image,
		   BACKGROUND_DIFFERENCE,
		   flag,class_1,class_2,
		   rst, clk);
		  
   input [7:0] luma_ch, cb_ch, cr_ch,class_1,class_2;
   input       BACKGROUND_DIFFERENCE;
   
   output      object_image,flag;
   input 	rst, clk;

   reg  	object_image;
   reg   BACKGROUND_SCAN_COMPLETE;
   reg [19:0] 	counter;
  // reg [15:0]  column;
  // reg [7:0] 	diff;
 //  reg[7:0]     luma_bg=0;
 
    parameter IMAGE_WIDTH=384;
    parameter IMAGE_HIGHT=216;
      
  assign flag= BACKGROUND_SCAN_COMPLETE;
  
  always@(posedge clk)begin
        if(rst)begin
            counter<=0;
       //     column<=0;
            end
        else begin
            counter <= counter + 1'b1;
         //   column <= counter%160;
            end
  end
   
always @(posedge clk) begin
  if (rst)
        begin
	       object_image <= 0;
	       BACKGROUND_SCAN_COMPLETE<=0;
	    end
  else begin

	 // if we are using the background difference method
	 if(BACKGROUND_DIFFERENCE) begin
	    // check if the scan is complete
	   
	   
	if(!BACKGROUND_SCAN_COMPLETE) 	   
	    begin
         if (luma_ch<((class_1/2+class_2/2)) ) //in white background test 30 is better
               begin
                 object_image <= 1'b1;
            //     diff<=luma_bg - luma_ch;
               end
           else
              begin
                object_image <= 1'b0;	
              //  diff<=luma_bg - luma_ch;
              end       
	       // luma_bg <= luma_ch;
	       if(counter == IMAGE_WIDTH*IMAGE_HIGHT) begin
		       BACKGROUND_SCAN_COMPLETE <= 1;
	       end
	            else
		        BACKGROUND_SCAN_COMPLETE <= 0;
	    end
	   else begin
	       object_image <= 0;
	    end
	  end
   end
end // always @ (posedge clk)
   
endmodule // SkinDecider


	 
     
   
       