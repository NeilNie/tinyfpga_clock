// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
  input CLK,      // 16MHz clock
  output LED,     // User/boot LED next to power LED
  output PIN_1,    // PIN_1
  output PIN_2,
  output PIN_3,
  output PIN_4,
  output PIN_5,
  output PIN_6,
  output PIN_7,
  output PIN_20,
  output PIN_21,
  output PIN_22,
  output PIN_23   //
);

  reg [6:0] display_out;
  reg [3:0] input_val;
  reg [32:0] blink_counter;

  initial begin
    blink_counter <= 0;
    input_val <= 4'b0000;
  end

  assign PIN_21 = 0;
  assign PIN_22 = 0;
  assign PIN_23 = 0;
  assign PIN_20 = 0;

  // increment the blink_counter every clock
  always @(posedge CLK) begin
      blink_counter <= blink_counter + 1;
      if (blink_counter % 16000000 == 0) begin
        if (input_val < 10) begin
          input_val <= input_val + 1;
        end else begin
          input_val <= 4'b0000;
        end
      end
  end

  display_decoder decoder(.in(input_val), .value(display_out));

  assign PIN_1 = display_out[6];
  assign PIN_2 = display_out[5];
  assign PIN_3 = display_out[4];
  assign PIN_4 = display_out[3];
  assign PIN_5 = display_out[2];
  assign PIN_6 = display_out[1];
  assign PIN_7 = display_out[0];

  endmodule
