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
  output PIN_8,
  output PIN_20,
  output PIN_21,
  output PIN_22,
  output PIN_23,   //
  input PIN_10,
  input PIN_11    //
);

  // for the seven segment display
  reg [6:0] display_out;
  reg [3:0] display_in;

  // regs that hold values for each digit of the clock.
  reg [3:0] minute_one;
  reg [3:0] minute_two;
  reg [3:0] hour_one;
  reg [3:0] hour_two;

  // user sets the minut and hour offset, which will be added
  // or subtracted from the minute or hour count.
  reg [3:0] minute_offset;
  reg [3:0] hour_offset;

  // the ground pins for the four seven segment displays.
  // those pins will be switch on and off to display different
  // digits at once.
  reg gnd_1;
  reg gnd_2;
  reg gnd_3;
  reg gnd_4;

  reg PIN_10_db;

  reg [32:0] blink_counter;
  reg [3:0] display_select_counter;

  initial begin
    blink_counter <= 0;
    minute_one <= 4'b0000;
    minute_two <= 4'b0000;
    hour_one <= 4'b0000;
    hour_two <= 4'b0000;
    minute_offset <= 4'b0000;
    hour_offset <= 4'b0000;
    display_select_counter <= 0;
  end

  always @(negedge PIN_11) begin

  end

  debounce db(.clk(CLK), .PB(PIN_10), .PB_state(PIN_10_db));

  always @ (posedge PIN_10_db) begin
    minute_offset <= minute_offset + 1;
  end

  // increment the blink_counter every clock
  always @(posedge CLK) begin

      hour_one = hour_one + minute_offset;
      if (blink_counter % 16000000 == 0) begin
        if (minute_one < 9) begin
          minute_one <= minute_one + 1;
        end else if (minute_one == 9 && minute_two < 5) begin
          minute_one <= 4'b0000;
          minute_two <= minute_two + 1;
        end else if (minute_one == 9 && minute_two == 5) begin
          hour_one <= hour_one + 1;
          minute_one <= 4'b0000;
          minute_two <= 4'b0000;
        end
      end

      if (blink_counter % 500 == 0) begin
        if (display_select_counter == 0) begin
          gnd_1 = 0;
          gnd_2 = 1;
          gnd_3 = 1;
          gnd_4 = 1;
          display_in <= hour_two;
          display_select_counter <= display_select_counter + 1;
        end else if (display_select_counter == 1) begin
          gnd_1 = 1;
          gnd_2 = 0;
          gnd_3 = 1;
          gnd_4 = 1;
          display_in <= minute_offset;
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

      blink_counter <= blink_counter + 1;

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

  assign PIN_8 = PIN_10;

  endmodule
