CON

    HIGH    = 1
    LOW     = 0
    OUTPUT  = 1
    INPUT   = 0

VAR

    long _range_stack[50], _cog
    long _TRIG, _ECHO
    long _1us
    long _rtt

OBJ

    time: "time"

PUB startx(TRIG_PIN, ECHO_PIN): status
' Start the driver using custom I/O settings
'   TRIG_PIN: ultrasonic transducer trigger (out) pin
'   ECHO_PIN: ultrasonic transducer echo (in) pin
'   Returns: cog ID+1
    longmove(@_TRIG, @TRIG_PIN, 2)
    status := _cog := (cognew(cog_range{}, @_range_stack) + 1)
    _1us := (clkfreq / 1_000_000)

PUB stop{}
' Stop the driver
    if (_cog)
        cogstop(_cog~ - 1)
    longfill(@_range_stack, 0, 53)

PUB inches{} : dist
' Measure object distance in inches
    dist := _rtt * 1_000 / _to_in

PUB centimeters{} : dist
' Measure object distance in centimeters
    dist := millimeters{} / 10

PUB millimeters{}: dist
' Measure object distance in millimeters
    dist := _rtt * 10_000 / _to_cm

PUB calibrate(Tamb)
' Adjust Ping))) calibration constants to reflect ambient
' temperature impact on speed of sound (temperature assumed to be °F)
    Tamb += 460
    _to_in := _to_in_std * (^^(Tamb * 1_000_000)) / (^^518_690_000)
    _to_cm := _to_in * _to_cm_std / _to_in_std

PRI cog_range{} | cnt1, cnt2

    outa[_TRIG] := LOW
    dira[_TRIG] := OUTPUT
    dira[_ECHO] := INPUT

    repeat
        outa[_TRIG] := HIGH
        time.usleep(10)
        outa[_TRIG] := LOW

        waitpne(0, |< _ECHO, 0)
        cnt1 := cnt
        waitpeq(0, |< _ECHO, 0)
        cnt2 := cnt
        _rtt := (||(cnt1 - cnt2) / _1us) >> 1


DAT

    _to_in  long    74_641
    _to_cm  long    29_386

