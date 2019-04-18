// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
  input CLK,       // 16MHz clock
  output PIN_1,    // PIN_1
  output PIN_2,
  output PIN_3,
  output PIN_4,
  output PIN_5,
  output PIN_6,
  output PIN_7,
  output PIN_8,
  output PIN_9,
  output PIN_10,
  output PIN_11,    //
  output PIN_12,
  output PIN_13,
  output PIN_14,
  output PIN_15,
  output PIN_16,
  output PIN_17,
  output PIN_18,
  output PIN_20,
  output PIN_21,

  input PIN_23,
  input PIN_24  //
);

  // for the seven segment display
  reg [6:0] display_out;
  reg [3:0] display_in;

  // regs that hold values for each digit of the clock.
  reg sec_ind;
  reg [15:0] min_time_count;
  reg [15:0] hour_time_count;
  reg [15:0] hour_time_count_2;

  // the ground pins for the four seven segment displays.
  // those pins will be switch on and off to display different
  // digits at once.
  reg gnd_1;
  reg gnd_2;
  reg gnd_3;
  reg gnd_4;

  reg PIN_23_db;
  reg PIN_24_db;

  reg [32:0] blink_counter;
  reg [3:0] display_select_counter;

  initial begin
    sec_ind <= 0;
    blink_counter <= 0;
    display_select_counter <= 0;
    min_time_count <= 0;
    hour_time_count <= 0;

    PIN_23_db <= 0;
    PIN_24_db <= 0;
  end

  // debounce db1(.clk(CLK), .PB(~PIN_23), .PB_state(PIN_23_db));
  // debounce db2(.clk(CLK), .PB(~PIN_24), .PB_state(PIN_24_db));

  // increment the blink_counter every clock
  always @(posedge CLK) begin

      if (blink_counter % 12000000 == 0) begin

        min_time_count <= min_time_count + 1;
        sec_ind = ~sec_ind;

        if (PIN_23_db == 1) begin
          min_time_count <= min_time_count + 60;
        end

        if (PIN_24_db == 1) begin
          hour_time_count <= hour_time_count + 1;
        end

        if ((min_time_count / 60) / 10 == 5 && ((min_time_count / 60) % 10) == 9) begin
            min_time_count <= 0;
            hour_time_count <= hour_time_count + 1;
        end

        if (hour_time_count == 9) begin
          hour_time_count <= 0;
          hour_time_count_2 = hour_time_count_2 + 1;
        end

      end

      if (blink_counter % 1000 == 0) begin

        if (display_select_counter == 0) begin
        gnd_1 = 0;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= hour_time_count_2;

        display_select_counter <= display_select_counter + 1;

        end else if (display_select_counter == 1) begin

        gnd_1 = 1;
        gnd_2 = 0;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= hour_time_count;

        display_select_counter <= display_select_counter + 1;

        end else if (display_select_counter == 2) begin

        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 0;
        gnd_4 = 1;
        display_in <= (min_time_count / 60) / 10;
        display_select_counter <= display_select_counter + 1;

        end else if (display_select_counter == 3) begin

        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 0;
        display_in <= (min_time_count / 60) % 10;
        display_select_counter <= 0;
        end

      end

      blink_counter <= blink_counter + 1;
  end

  display_decoder decoder(.in(display_in), .value(display_out));

  assign PIN_14 = gnd_1;
  assign PIN_17 = gnd_2;
  assign PIN_18 = gnd_3;
  assign PIN_8 = gnd_4;

  assign PIN_15 = display_out[6];
  assign PIN_19 = display_out[5];
  assign PIN_10 = display_out[4];
  assign PIN_12 = display_out[3];
  assign PIN_13 = display_out[2];
  assign PIN_16 = display_out[1];
  assign PIN_9 = display_out[0];

  assign PIN_20 = sec_ind;
  assign PIN_7 = 0;

  endmodule
