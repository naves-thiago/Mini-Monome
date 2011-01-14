-- Load Midi module
midi = require( "eluamidi" )

-- Configure P13 to UART
mbed.pio.configpin( mbed.pio.P13, 1, 0, 0 )

-- Initialize midi
midi.init( 1 )


local btn_pin  = {} -- Pins connected to the buttons
local btn_val  = {} -- Buttons states ( 0 = pressed, 1 = up )
local btn_note = {} -- The note each button triggers
local btn_led  = {} -- Pins of the leds 

local tmp
local i -- Loop

-- Received messages values
local code, note, vel

-- Initialization
btn_pin[0] = mbed.pio.P10
btn_pin[1] = mbed.pio.P9
btn_pin[2] = mbed.pio.P16
btn_pin[3] = mbed.pio.P15

btn_val[0] = 1
btn_val[1] = 1
btn_val[2] = 1
btn_val[3] = 1

btn_note[0] = 64
btn_note[1] = 65
btn_note[2] = 66
btn_note[3] = 67

btn_led[0] = mbed.pio.LED1
btn_led[1] = mbed.pio.LED2
btn_led[2] = mbed.pio.LED3
btn_led[3] = mbed.pio.LED4

-- Set button pins as inputs and led as outputs
for i=0,3 do
  pio.pin.setdir( pio.INPUT, btn_pin[i] )
  pio.pin.setdir( pio.OUTPUT, btn_led[i] )
end

-- Main Loop
while ( true ) do 
  for i=0,3  do
    -- Get button state
  --  term.print( btn_pin[i] .. "")
    tmp = pio.pin.getval( btn_pin[i] )

    -- State changed ?
    if ( tmp ~= btn_val[i] ) then
      btn_val[i] = tmp

      -- Button is presse ?
      if ( tmp == 0 ) then
        midi.send_note_on( 1, btn_note[i], 64 )
      else
        midi.send_note_off( 1, btn_note[i], 64 )
      end
    end
  end

  -- Debounce
  tmr.delay( 2, 500 )

  -- Look for a midi message
  if ( midi.receive( 500, 2 ) == midi.defs[ "msg_new_message" ] ) then
    code = midi.message[ midi.defs[ "msg_code" ] ]
    note = midi.message[ midi.defs[ "msg_data" ] ]
    vel  = midi.message[ midi.defs[ "msg_data2" ] ]

    if (( code == midi.defs[ "note_on" ] ) and ( vel == 127 )) then
      for i=0,3 do
        if ( code == btn_note[i] ) then
          pio.pin.sethigh( btn_led[i] )
        end
      end
    end

    if (( code == midi.defs[ "note_off" ] ) and ( vel == 0 )) then
      for i=0,3 do
        if ( code == btn_note[i] ) then
          pio.pin.setlow( btn_led[i] )
        end
      end
    end
end

