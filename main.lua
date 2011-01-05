midi = require( "eluamidi" )
brd=require"EK-LM3S6965"

midi.init( 2 )

local a = 1
local b = 1
local c = 1
local d = 1
local tmp

while ( true ) do 
  tmp = pio.pin.getval( brd.BTN_UP )
  if ( tmp ~= a ) then
    a = tmp
    if ( a == 0 ) then
      midi.send_note_on( 1, 64, 64 )
    else
      midi.send_note_off( 1, 64, 64 )
    end
  end

  tmp = pio.pin.getval( brd.BTN_DOWN )
  if ( tmp ~= b ) then
    b = tmp
    if ( b == 0 ) then
      midi.send_note_on( 1, 65, 64 )
    else
      midi.send_note_off( 1, 65, 64 )
    end
  end

  tmp = pio.pin.getval( brd.BTN_LEFT )
  if ( tmp ~= c ) then
    c = tmp
    if ( c == 0 ) then
      midi.send_note_on( 1, 66, 64 )
    else
      midi.send_note_off( 1, 66, 64 )
    end
  end

  tmp = pio.pin.getval( brd.BTN_RIGHT )
  if ( tmp ~= d ) then
    d = tmp
    if ( d == 0 ) then
      midi.send_note_on( 1, 67, 64 )
    else
      midi.send_note_off( 1, 67, 64 )
    end
  end

  tmr.delay( 2, 500 )
end

