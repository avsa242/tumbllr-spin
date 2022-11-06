{
    --------------------------------------------
    Filename: Tumbllr-P8X32A.spin
    Author: Jesse Burt
    Description: Main application for the alternative P8X32A-based Tumbllr
        balacning robot
    Copyright (c) 2022
    Started Nov 6, 2022
    Updated Nov 6, 2022
    See end of file for terms of use.
    --------------------------------------------
}

#define DEBUG_ENA
CON

    SER_BAUD        = 115_200

    { IMU: MPU6050 }
    I2C_SCL         = 28
    I2C_SDA         = 29
    I2C_HZ          = 400_000
    ADDR_BITS       = 0


    { motors }
    MOTOR_PWM_FREQ  = 8_000
    STBY_PIN        = 8                         ' 1: active, 0: standby

    AIN1_PIN        = 7                         ' motor 1 drive direction
    APWM_PIN        = 5                         ' motor 1 duty
    M1A_PIN         = 4                         ' motor 1 encoder

    BIN1_PIN        = 12
    BPWM_PIN        = 6
    M2A_PIN         = 2

    { motor, encoder characteristics }
    ENC_POLES       = 26
    ENC_PPR         = ENC_POLES/2               ' half are N, half are S
    GRATIO          = 30


    { smart LEDs }
    RGB_PIN         = 3
    TOTAL_LEDS      = 4
    LED_RT_REAR     = 0                         ' map LEDs in array to physical positions
    LED_LT_REAR     = 1
    LED_LT_FRT      = 2
    LED_RT_FRT      = 3


    { IR }
    IR_TX_PIN       = 9
    IR_RX_LT_PIN    = 22
    IR_RX_RT_PIN    = 23
    IRM_56384_FREQ  = 38_000                    ' modulation frequency
    IR_TX_HALF_PER  = ((80_000_000 / IRM_56384_FREQ) / 2)


    { ultrasonic }
    RANGE_TRIG_PIN  = 11
    RANGE_ECHO_PIN  = 25

' --

    { I/O general-purpose symbols }
    HIGH            = 1
    LOW             = 0

    INPUT           = 0
    OUTPUT          = 1

VAR

    { motors }
    long _duty
    long _rgb[TOTAL_LEDS]

OBJ
                                                ' cores used
    imu:    "sensor.imu.6dof.mpu6050"           ' 1
    motor:  "motor.brushed.hbridge-pwm"         ' 1
    rgb:    "display.led.smart"                 ' 1
#ifdef DEBUG_ENA
    ser:    "com.serial.terminal.ansi"          ' 1
#endif
    time:   "time"                              ' 0
    range:  "sensor.range.ultrasonic"           ' 1
                                                ' -
                                                ' 6 (above + core #0)

PUB main()

    setup()

    repeat

PUB setup()

#ifdef DEBUG_ENA
    ser.start(SER_BAUD)
    time.msleep(20)
    ser.clear()
    ser.strln(@"Serial debug started")
#endif


    if (imu.startx(I2C_SCL, I2C_SDA, I2C_HZ, ADDR_BITS))
#ifdef DEBUG_ENA
        ser.strln(@"IMU started")
#endif
        imu.preset_active{}
        imu.clock_src(imu.PLL_GYRO_X)
    else
#ifdef DEBUG_ENA
        ser.strln(@"IMU failed to start")
#endif
        repeat


    _duty := 0
    if (motor.start(APWM_PIN, AIN1_PIN, BPWM_PIN, BIN1_PIN, MOTOR_PWM_FREQ))
#ifdef DEBUG_ENA
        ser.strln(@"Motor driver started")
#endif
    else
#ifdef DEBUG_ENA
        ser.strln(@"Motor driver failed to start - halting")
#endif
        repeat


    rgb.start(RGB_PIN, TOTAL_LEDS, 1, rgb.WS2812B, @_rgb)

    outa[IR_TX_PIN] := LOW
    dira[IR_TX_PIN] := OUTPUT

    if (range.startx(RANGE_TRIG_PIN, RANGE_ECHO_PIN))
#ifdef DEBUG_ENA
        ser.strln(@"Range sensor driver started")
#endif
    else
#ifdef DEBUG_ENA
        ser.strln(@"Range sensor driver failed to start - halting")
#endif
        repeat


DAT
{
Copyright 2022 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
}

