module PalmIdentification(object_image,
			  finger_width,
			  start_of_palm_c,
			  end_of_palm_c,
			  palm_width,
			  flag,			  
			  rst,clk);
  
   input object_image,flag;
   output [8:0]  start_of_palm_c,end_of_palm_c, palm_width,finger_width;
   input 	rst, clk;

   
   reg [8:0] 	 start_of_palm_c,  end_of_palm_c,  palm_width,finger_width;
   // A flag to check if the entire first line is received
   reg 		FOUND_PALM_START=0, FOUND_PALM_END=0;
   // The dimensions of the image
  parameter IMAGE_WIDTH=384;
  parameter IMAGE_HEIGHT=216;
  
   reg [8:0] 	row_count = 0, col_count = 0;
   // flag to indicate 'break out of id mode'
   reg 		INNERBREAK = 0;
   reg [8:0] palm_width_max,start_of_palm_c_max,end_of_palm_c_max,finger_width_max;
   reg [8:0] start_of_palm_r,end_of_palm_r,finger_width_r;
   
   always @(posedge clk) begin
      if (rst) begin
	 start_of_palm_c = 9'b0;
	 end_of_palm_c = 9'b0;
	 col_count = 9'b0;
	 row_count =9'b0;
	 start_of_palm_c_max = 9'b0;
     end_of_palm_c_max = 9'b0;
     palm_width = 9'b0;
     palm_width_max=9'b0;
     finger_width =9'b0;
     finger_width_max=9'b0;
      end

      else begin
	 // Keep track of the image row and columns
	 if(col_count >= IMAGE_WIDTH-1) begin
	    // columns should not exceed image_width
	    col_count = 0;
	    // increment row after 1 scan of column
	    row_count = row_count + 1;
	 end
	 else begin
	    // still in the same column
   	    col_count = col_count + 1;
	 end	
	    // found hand pixel
	    if(object_image && !flag) begin
	       // check if the start of palm has been found
	       if(FOUND_PALM_START == 0) begin
		       // if not mark it as the start of palm
		       FOUND_PALM_START <= 1;
		      // record the row and column values
		      start_of_palm_c <= col_count;
	       end // if(FOUND_PALM_START)
	       else FOUND_PALM_START <= 1;
	     end
	    else if(!flag)begin //if object_image==0	            
		        end_of_palm_c = col_count;
		        // Mark that the end of palm has been found
		        if(FOUND_PALM_START ==1)FOUND_PALM_END = 1;
	       end 
        else begin
            end_of_palm_c= end_of_palm_c_max;
            start_of_palm_c=start_of_palm_c_max;
        end
 /*    end // else: !if(rst)
end // always @ (posedge clk)	       
           
           
always@(posedge FOUND_PALM_END or posedge rst)begin
if(rst)begin
        start_of_palm_c_max <= 9'b0;
        end_of_palm_c_max <= 9'b0;
        palm_width <= 9'b0;
        palm_width_max<=9'b0;
        finger_width <=9'b0;
        finger_width_max<=9'b0;
end
else begin*/
if(FOUND_PALM_END==1)begin
    if(end_of_palm_c >start_of_palm_c)
        begin
            if(palm_width_max < (end_of_palm_c - start_of_palm_c))  begin
             palm_width = end_of_palm_c - start_of_palm_c;
             end_of_palm_c_max = end_of_palm_c ;
             start_of_palm_c_max=start_of_palm_c;
             end
            else if(row_count>IMAGE_HEIGHT/2)begin
                        if(finger_width_max < (end_of_palm_c - start_of_palm_c) )  begin
                        finger_width = end_of_palm_c - start_of_palm_c;
                        if(finger_width>palm_width/10 && finger_width < palm_width/4 && finger_width_max<finger_width) finger_width_max = finger_width;
                        else finger_width_max=finger_width_max;
                        end
            end
        end
    else 
        palm_width =palm_width_max;
    palm_width_max =palm_width;
		  if (palm_width > IMAGE_WIDTH/5) begin
		     // Stop accepting the incoming pixels
		     INNERBREAK <= 1;
		   	
        end
          FOUND_PALM_START  = 0;
          FOUND_PALM_END = 0;
end	
end
end
endmodule // PalmIdentification

