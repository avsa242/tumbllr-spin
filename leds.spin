CON

    _clkmode= xtal1 + pll16x
    _xinfreq= 5_000_000

    { LEDs, by position }
    RR      = 0
    LR      = 1
    FL      = 2
    FR      = 3

OBJ

    ser: "com.serial.terminal.ansi"
    time: "time"
    rgb: "display.led.smart"

var

    long _rgb[4]

PUB main | c, p

    ser.start(115200)
    time.msleep(20)
    ser.clear

    rgb.start(3, 4, 1, rgb.WS2812B, @_rgb)

    p := RR
    c := 1
    repeat
        rgb.plot(p, 0, c << 8)
        c++
        if (c > 16777215)
            c := 1
        c <<= 1
        p++
        if (p > FR)
            p := RR
    repeat

