CON

    _clkmode= xtal1 + pll16x
    _xinfreq= 5_000_000

    HIGH    = 1
    LOW     = 0

    INPUT   = 0
    OUTPUT  = 1

    { motors }
    STBY    = 8 '1: active, 0: standby

    AIN1    = 7
    APWM    = 5
    M1A     = 4

    BIN1    = 12
    BPWM    = 6
    M2A     = 2

    ENC_POLES   = 26
    ENC_PPR     = ENC_POLES/2 ' half are N, half are S
    GRATIO      = 30

OBJ

    ser: "com.serial.terminal.ansi"
    time: "time"
    motor: "motor.brushed.hbridge-pwm"

var

    long _tmr_stk[50], _key_stk[50]
    word _duty

PUB main | pls, time_ms, inp, last, pcnt, enc_rpm, mot_rpm
' 22p/enc rev, 1:30 ratio; 330p/motor rev
    cognew(cog_timer, @_tmr_stk)
    cognew(cog_key, @_key_stk)

    ser.start(115200)
    time.msleep(20)
    ser.clear
{
    pcnt := 0
    last := ina[M1A]
    repeat
        inp := ina[M1A]
        if (inp <> last)
            pcnt++
            ser.printf1(@"%d pulses\n\r", pcnt)
        last := inp
}
    outa[STBY] := 0
    dira[STBY] := 1

    outa[AIN1] := 1
    outa[BIN1] := 1
    dira[AIN1] := 1
    dira[BIN1] := 1

    dira[M1A] := 0
    dira[M2A] := 0

    outa[STBY] := 1

'    if motor.start(APWM, -1, BPWM, -1, 8000)
'        ser.strln(@"motor started")

    time.msleep(1)
    time_ms := 1000

'    motor.both_duty(_duty)

    repeat
        _timer_set := time_ms
        pls := 0
        repeat while _timer_set
            waitpeq(|< M1A, |< M1A, 0)
            pls++
            waitpne(|< M1A, |< M1A, 0)
        report("A", pls)

        _timer_set := time_ms
        pls := 0
        repeat while _timer_set
            waitpeq(|< M2A, |< M2A, 0)
            pls++
            waitpne(|< M2A, |< M2A, 0)
        report("B", pls)

    repeat

var long _timer_set

PRI Report(mot, pulse_cnt) | enc_rpm, mot_rpm
' Display benchmark test results
    enc_rpm := (((pulse_cnt * 1_000) / ENC_PPR) * 60) / 1000
    mot_rpm := (enc_rpm * 10) / GRATIO
    ser.printf2(string("(%c) Encoder RPM: %d\n\r"), mot, enc_rpm)
    ser.printf3(string("(%c) Motor RPM: %d.%0d\n\r"), mot, mot_rpm/10, mot_rpm//10)

    ser.newline{}

pri cog_key{}

    _duty := 0
    if motor.start(APWM, -1, BPWM, -1, 8000)
        ser.strln(@"motor started")
    repeat
        case ser.rxcheck
            "+":
                _duty := (_duty + 10) <# 100_0
            "-":
                _duty := (_duty - 10) #> 0
        motor.both_duty(_duty)

PRI cog_timer{} | time_left
' Benchmark timer loop
    repeat
        repeat until _timer_set                 ' wait here until a timer has
        time_left := _timer_set                 '   been set

        repeat                                  ' loop for time_left ms
            time_left--
            time.msleep(1)
        while time_left > 0
        _timer_set := 0                         ' signal the timer's been reset


