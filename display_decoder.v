// Most of this code is not mine
// http://referencedesigner.com/tutorials/verilog/verilog_19.php
// *****************************

module display_decoder(
  in,
  value
  );

  input [3:0] in;
  output [6:0] value;

  always @(*)
  case (in)
  4'b0000 :      	//Hexadecimal 0
  value = 7'b1111110;
  4'b0001 :    		//Hexadecimal 1
  value = 7'b0110000  ;
  4'b0010 :  		// Hexadecimal 2
  value = 7'b1101101 ;
  4'b0011 : 		// Hexadecimal 3
  value = 7'b1111001 ;
  4'b0100 :		// Hexadecimal 4
  value = 7'b0110011 ;
  4'b0101 :		// Hexadecimal 5
  value = 7'b1011011 ;
  4'b0110 :		// Hexadecimal 6
  value = 7'b1011111 ;
  4'b0111 :		// Hexadecimal 7
  value = 7'b1110000;
  4'b1000 :     		 //Hexadecimal 8
  value = 7'b1111111;
  4'b1001 :    		//Hexadecimal 9
  value = 7'b1111011 ;
  endcase

endmodule
