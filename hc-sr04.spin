CON

    _clkmode = xtal1 + pll16x
    _xinfreq = 5_000_000

    TRIG   = 11  ' Connected to P1
    ECHO   = 25  ' Connected to P0

    HIGH   = 1
    LOW    = 0

    INPUT  = 0
    OUTPUT = 1

OBJ
    ser: "com.serial.terminal.ansi"
    time: "time"


PUB Main | us, dist, cnt1, cnt2

    ser.start(115200)
    time.msleep(20)
    ser.clear
    ' set pin directions
    outa[TRIG] := LOW
    dira[TRIG] := OUTPUT
    dira[ECHO] := INPUT

    REPEAT
        outa[TRIG] := HIGH
'        pause10us(1)
        time.usleep(10)
        outa[TRIG] := LOW

        waitpne(0, |< ECHO, 0)
        cnt1 := cnt
        waitpeq(0, |< ECHO, 0)
        cnt2 := cnt
        us := (||(cnt1 - cnt2) / _1US) >> 1

        ser.position(0, 5)
        ser.printf1(@"%6.6dus\n\r", us)
        ser.printf1(@"%6.6dmm\n\r", millimeters(us))

'        pause1ms(100)

con

    CLK_FREQ= (_clkmode >> 6) * _xinfreq
    _1US    = CLK_FREQ/1_000_000

PUB Inches(us) : dist
''Measure object distance in inches
    dist := us * 1_000 / TO_IN

PUB Centimeters(us) : dist                                                  
''Measure object distance in centimeters
    dist := Millimeters(us) / 10

PUB millimeters(us) : dist                                                  
' Measure object distance in millimeters
    dist := us * 10_000 / TO_CM

PUB calibrate(Tamb)
' Adjust Ping))) calibration constants to reflect ambient 
' temperature impact on speed of sound (temperature assumed to be °F)
    Tamb += 460
    TO_IN := TO_IN_std * (^^(Tamb * 1_000_000)) / (^^518_690_000)
    TO_CM := TO_IN * TO_CM_std / TO_IN_std

con

    _10us = 1_000_000 /        10                         ' Divisor for 10 us
    _1ms  = 1_000_000 /     1_000                         ' Divisor for 1 ms
    _1s   = 1_000_000 / 1_000_000                         ' Divisor for 1 s

PUB pause10us(period)
' Pause execution for period (in units of 10 us)
    clkcycles := ((clkfreq / _10us * period) - 4296) #> 381    ' Calculate 10 us time unit
    waitcnt(clkcycles + cnt)                                   ' Wait for designated time

PUB pause1ms(period)
' Pause execution for period (in units of 1 ms).
    clkcycles := ((clkfreq / _1ms * period) - 4296) #> 381     ' Calculate 1 ms time unit
    waitcnt(clkcycles + cnt)                                   ' Wait for designated time
  
PUB pause1s(period)
' Pause execution for period (in units of 1 sec).
    clkcycles := ((clkfreq / _1s * period) - 4296) #> 381      ' Calculate 1 s time unit
    waitcnt(clkcycles + cnt)                                   ' Wait for designated time

DAT

    TO_IN         LONG      74_641                  '
    TO_CM         LONG      29_386      

