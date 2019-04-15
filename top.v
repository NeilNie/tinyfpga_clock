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
  reg sec_ind;
  reg [15:0] time_count;

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
    time_count <= 0;
    sec_ind <= 0;
    blink_counter <= 0;
    display_select_counter <= 0;
  end

  debounce db(.clk(CLK), .PB(~PIN_10), .PB_state(PIN_10_db));

  // increment the blink_counter every clock
  always @(posedge CLK) begin

      if (blink_counter % 2500000 == 0) begin
        if (PIN_10_db == 1) begin
          time_count <= time_count + 60;
        end
      end

      if (blink_counter % 10000000 == 0) begin
        time_count <= time_count + 1;
        // sec_ind = ~sec_ind;
      end

      if (blink_counter % 500 == 0) begin

        if (display_select_counter == 0) begin
        gnd_1 = 0;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= (time_count / 3600) / 10;
        display_select_counter <= display_select_counter + 1;
        end else if (display_select_counter == 1) begin

        gnd_1 = 1;
        gnd_2 = 0;
        gnd_3 = 1;
        gnd_4 = 1;
        display_in <= (time_count / 3600) % 10;
        display_select_counter <= display_select_counter + 1;

        end else if (display_select_counter == 2) begin

        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 0;
        gnd_4 = 1;
        display_in <= (time_count / 60) / 10;
        display_select_counter <= display_select_counter + 1;

        end else if (display_select_counter == 3) begin

        gnd_1 = 1;
        gnd_2 = 1;
        gnd_3 = 1;
        gnd_4 = 0;
        display_in <= (time_count / 60) % 10;
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

  // assign PIN_8 = sec_ind;

  endmodule
