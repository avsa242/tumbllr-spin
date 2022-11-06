CON

    _clkmode    = xtal1 + pll16x
    _xinfreq    = 5_000_000

    HIGH        = 1
    LOW         = 0

    INPUT       = 0
    OUTPUT      = 1

' --
    IR_TX       = 9
    IR_RX_L     = 22
    IR_RX_R     = 23

    { LEDs, by position }
    RR          = 0
    LR          = 1
    FL          = 2
    FR          = 3
' --

VAR

    long _rgb[4]

OBJ

    ser: "com.serial.terminal.ansi"
    time: "time"
    rgb : "display.led.smart"

PUB main | pls, time_ms

    ser.start(115200)
    time.msleep(20)
    ser.clear

    cognew(cog_ir_tx(), @_ir_tx_stack)

    rgb.start(3, 4, 1, rgb.WS2812B, @_rgb)
    dira[IR_RX_L] := INPUT
    dira[IR_RX_R] := INPUT

    repeat
        ifnot (ina[IR_RX_L])
            rgb.plot(FL, 0, $7f_00_00_00)
        else
            rgb.plot(FL, 0, 0)
        ifnot (ina[IR_RX_R])
            rgb.plot(FR, 0, $7f_00_00_00)
        else
            rgb.plot(FR, 0, 0)

VAR long _ir_tx_stack[50]
CON IRM_56384_FREQ  = 38_461
CON IR_TX_HALF_PER  = ((80_000_000 / IRM_56384_FREQ) / 2)
PUB cog_ir_tx() | halfper
' modulate IR_TX LEDs at 38kHz (both L & R are electrically tied to the same I/O pin)
    outa[IR_TX] := LOW
    dira[IR_TX] := OUTPUT

    halfper := ((clkfreq / IRM_56384_FREQ) / 2)
    repeat
        repeat 40
            outa[IR_TX] := LOW
            waitcnt(cnt + halfper)
            outa[IR_TX] := HIGH
            waitcnt(cnt + halfper)

