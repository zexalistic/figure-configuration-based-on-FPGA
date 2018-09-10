//In this modulet parameter thumb,index,middle.ring,pinky are to be determined by your image.
//Thus, the volume of reg thumb_true should be changed with them.
module FingerIdentification(object_image,
                            flag,
                            palm_width,
                            start_of_palm_c,
                            end_of_palm_c,
                            thumb_status,
                            index_status,
                            middle_status,
                            ring_status,
                            pinky_status,
                            finger_width,
                            rst,clk);
   
   input object_image;
   input [8:0] palm_width, finger_width;
   input [8:0]  start_of_palm_c;
   input [8:0]  end_of_palm_c;
   
   output      thumb_status, index_status, middle_status, ring_status, pinky_status;
   
   input       rst, clk,flag;
   
   // Finger status indicators,
   // if open, status is `True`
   // else status is `False`
   reg         thumb_status=0;
   reg 	       index_status=0;
   reg 	       middle_status=0;
   reg 	       ring_status=0;
   reg 	       pinky_status=0;
   
   // The dimensions of the image
   parameter IMAGE_WIDTH=384;
   parameter IMAGE_HEIGHT=216;
   reg [8:0] 	row_count = 0, col_count = 0;
   
   reg[17:0]    count;
   reg [7:0] 	lum[0:IMAGE_WIDTH*IMAGE_HEIGHT];
   
   // Threshold triggers
   reg [9:0]   pinky_true=0;
   reg [9:0]   ring_true=0;
   reg [9:0]   middle_true=0;
   reg [9:0]   index_true=0;
   reg [9:0]   thumb_true=0;
   
   // FInger boxes
   reg [8:0]   pinky_left = 0;
   reg [8:0]   pinky_right = 0;
   
   reg [8:0]   ring_left = 0;
   reg [8:0]   ring_right = 0;

   reg [8:0]   middle_left = 0;
   reg [8:0]   middle_right = 0;
   
   reg [8:0]   thumb_left = 0;
   reg [8:0]   thumb_right = 0;
   
   reg [8:0]   index_left = 0;
   reg [8:0]   index_right = 0;
  
   parameter thumb=150;
   parameter index=150;
   parameter middle=350;
   parameter ring=300;
   parameter pinky=150;
   
   always@(posedge clk)begin
        if(rst) begin
                    count=0;
                end
        else begin
              if(count<IMAGE_WIDTH*IMAGE_HEIGHT && !flag)begin
                  lum[count]=object_image;
                  count=count+1;
               end
        end
  end
   
  always@(posedge clk)begin
        if(!rst)
            begin
                if( col_count > (pinky_right + (row_count-90)/5) && col_count < pinky_left && row_count>90) begin  //the slope of ring fingure is about tan^-1(0.2)
                          if(lum[row_count*IMAGE_WIDTH+col_count] == 1 && pinky_true<1000) begin
                              pinky_true <= pinky_true + 1;
                          end
                       end
                        
                if(col_count > ring_right && col_count < ring_left && row_count>90) begin           
                                     if(lum[row_count*IMAGE_WIDTH+col_count] == 1 && ring_true<1000) begin
                                         ring_true <= ring_true + 1;
                                     end
                                  end
                        if( col_count > index_right && col_count < index_left && row_count>90) begin
                                                if(lum[row_count*IMAGE_WIDTH+col_count]== 1 && index_true<1000) begin
                                                   index_true <= index_true + 1;
                                                end
                                             end
                     if( col_count > middle_right && col_count < middle_left && row_count>90) begin                       
                                                if(lum[row_count*IMAGE_WIDTH+col_count] == 1 && middle_true<1000) begin
                                                   middle_true <= middle_true + 1;
                                                end                                              
                                             end
                  if( col_count > thumb_right && col_count < thumb_left && row_count<126) begin     
                                                            if(lum[row_count*IMAGE_WIDTH+col_count] == 1 && thumb_true<1000) begin
                                                               thumb_true <= thumb_true + 1;
                                                            end                                                           
                                                         end
                       
            end
 end
 
 always@(posedge clk)begin
        if(rst)begin
                 thumb_status <= 0;
                 index_status <= 0;
                 middle_status <= 0;
                 ring_status <= 0;
                 pinky_status <= 0;
        end
        else begin
            if(thumb_true >thumb) begin
                  thumb_status <= 1;
             end
             else thumb_status <=0;
             if(middle_true > middle) begin
                     middle_status <= 1;
              end
              else middle_status <= 0;
              if(index_true >index) begin
                 index_status <= 1;
              end      
              else  index_status <= 0;
              if(ring_true >ring ) begin
                  ring_status <= 1;
               end
               else  ring_status <=0;
               if(pinky_true >pinky) begin
                  pinky_status <= 1;
               end     
               else pinky_status <= 0;                
        end
            
 end
  
   always @(posedge clk) begin
      if(rst) begin
         col_count<=0;
         row_count<=0;
      end
      
      else begin
 if(flag)
      begin  
	 // Keep track of the image row and columns
         if(col_count >= IMAGE_WIDTH-1) begin
            // columns should not exceed image_width
            col_count <= 0;
            // increment row after 1 scan of column
            row_count <= row_count + 1;
         end
         else begin
               col_count <= col_count + 1;
         end
	 
	 // The palm has been found, start calculating the fingers
         if (palm_width != 0) begin
	    
	    // Create the Finger Boxes, The dimensions are similar to that of design in matlab.
            // Calculate the status of each finger.If the no.of white pixels in the finger's box
	    // exceeds the threshold, set its status
 //           pinky_left <= end_of_palm_c + (palm_width >> 1 ) ;
 //           pinky_right <= end_of_palm_c - (palm_width >> 2 );
            pinky_left <= end_of_palm_c + (palm_width >> 1 ) ;
            pinky_right <= end_of_palm_c - finger_width/4;
           

//            ring_left <= end_of_palm_c - (palm_width >> 2 );
//            ring_right <=end_of_palm_c - palm_width /3;
            ring_left <= end_of_palm_c - finger_width;
            ring_right <=end_of_palm_c - finger_width*2;     
           

//            middle_left <= end_of_palm_c - palm_width /3 ;
//            middle_right <=  start_of_palm_c + palm_width /3 ;
            middle_left <= end_of_palm_c  - finger_width*2 ;
            middle_right <= end_of_palm_c  - finger_width*4 + finger_width/2 ;

            
//            index_left <= start_of_palm_c+palm_width/2 - 15; 
//            index_right <= start_of_palm_c;
            index_left <= end_of_palm_c  - finger_width*4 + finger_width/2 ; 
            index_right <= end_of_palm_c  - finger_width*5 ;
           
            
//            thumb_left <= start_of_palm_c ;
//            thumb_right <= 0;
            thumb_left <= start_of_palm_c;
            thumb_right <= 0;

            
         end // if (palm_width != 0)
   end //if(flag)
       
              
 end // else: !if(rst)
    
   end // always @ (posedge clk)
endmodule // FingerIdentification

