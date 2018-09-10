module SignToText(red_ch,
		  green_ch,
		  blue_ch,
		  BACKGROUND_DIFFERENCE,
	      class_1,class_2,
		  sign_value,
		  clk,rst);
   /*
    Top level module
    
    INPUT:
    red_ch - 8 bit, red component of image.
    green_ch - 8 bit, green component of image.
    blue_ch - 8 bit, blue component of image.
    
    FLAG:
    BACKGROUND_DIFFERENCE - Method of hand segmentation
    */
    
   input [7:0] red_ch, green_ch, blue_ch,class_1,class_2;
   input       BACKGROUND_DIFFERENCE;      
   input       clk, rst;
   wire      object_image;
    
   
   // Am i doing it right
   wire        rst, clk,flag;
   
   // Need a training mode switch
   wire [7:0]  luma_ch, cb_ch, cr_ch;
   RGBtoYCbCr dut_0 (.red_ch(red_ch),
		     .green_ch(green_ch),
		     .blue_ch(blue_ch),
		     .luma_ch(luma_ch),
		     .cb_ch(cb_ch),
		     .cr_ch(cb_ch),
		     .rst(rst),
		     .clk(clk));
   
 
   SkinDecider dut_1 (.luma_ch(luma_ch),
		      .cb_ch(cb_ch),	
		      .cr_ch(cr_ch),
		      .flag(flag),.class_1(class_1),.class_2(class_2),
		      .object_image(object_image),
		      .BACKGROUND_DIFFERENCE(BACKGROUND_DIFFERENCE),
		      .rst(rst), .clk(clk));
   
   wire [8:0]  start_of_palm_c;
   wire [8:0]  end_of_palm_c;
   wire [8:0]   palm_width,finger_width;
   PalmIdentification dut_2 (.object_image(object_image),
			     .start_of_palm_c(start_of_palm_c),
			     .end_of_palm_c(end_of_palm_c),
			     .palm_width(palm_width),
			     .finger_width(finger_width),
			     .flag(flag),		 
			     .rst(rst),.clk(clk));
   
   wire        thumb_status, index_status, middle_status, ring_status, pinky_status;
   FingerIdentification dut_3 (.object_image(object_image),
			       .palm_width(palm_width),
			       .finger_width(finger_width),
			       .start_of_palm_c(start_of_palm_c),
			       .end_of_palm_c(end_of_palm_c),
			       .thumb_status(thumb_status),
			       .index_status(index_status),
			       .middle_status(middle_status),
			       .ring_status(ring_status),
			       .pinky_status(pinky_status),
			       .flag(flag),
			       .rst(rst),.clk(clk));
   
  output wire [3:0]  sign_value;
   SignIdentification dut_4(.thumb_status(thumb_status),
			    .index_status(index_status),
			    .middle_status(middle_status),
			    .ring_status(ring_status),
			    .pinky_status(pinky_status),
			    .sign_value(sign_value),
			    .rst(rst),.clk(clk));
   
endmodule // SignToText


   
			       
