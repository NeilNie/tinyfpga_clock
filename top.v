// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
  input CLK,      // 16MHz clock
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
  reg [3:0] display_in;

  reg [3:0] minute_one;
  reg [3:0] minute_two;
  reg [3:0] hour_one;
  reg [3:0] hour_two;

  reg gnd_1;
  reg gnd_2;
  reg gnd_3;
  reg gnd_4;

  reg [32:0] blink_counter;
  reg [3:0] display_select_counter;

  initial begin
    blink_counter <= 0;
    minute_one <= 4'b0000;
    minute_two <= 4'b0000;
    hour_one <= 4'b0000;
    hour_two <= 4'b0000;
    display_select_counter <= 0;
  end

  // increment the blink_counter every clock
  always @(posedge CLK) begin
  
      blink_counter <= blink_counter + 1;
      if (blink_counter % 16000000 == 0) begin
        if (minute_one < 10) begin
          minute_one <= minute_one + 1;
        end else if (minute_one == 10 && minute_two < 60)begin
          minute_one <= 4'b0000;
          minute_two <= minute_two + 1;
        end else if (minute_two == 60) begin
          hour_one <= hour_one + 1;
        end
      end

      if (blink_counter % 500 == 0) begin

      if (display_select_counter == 0) begin
        gnd_1 = 0;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= 4'b0001;
        display_select_counter <= display_select_counter + 1;
      end else if (display_select_counter == 1) begin
        gnd_1 = 1;
        gnd_2 = 0;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= 4'b0010;
        display_select_counter <= display_select_counter + 1;
      end else if (display_select_counter == 2) begin
        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 0;
        gnd_4 = 1;
        display_in <= minute_two;
        display_select_counter <= display_select_counter + 1;
      end else if (display_select_counter == 3) begin
        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 0;
        display_in <= minute_one;
        display_select_counter <= 0;
      end
      end

  end

  assign PIN_20 = gnd_1;
  assign PIN_21 = gnd_2;
  assign PIN_22 = gnd_3;
  assign PIN_23 = gnd_4;

  display_decoder decoder(.in(display_in), .value(display_out));

  assign PIN_1 = display_out[6];
  assign PIN_2 = display_out[5];
  assign PIN_3 = display_out[4];
  assign PIN_4 = display_out[3];
  assign PIN_5 = display_out[2];
  assign PIN_6 = display_out[1];
  assign PIN_7 = display_out[0];

  endmodule
