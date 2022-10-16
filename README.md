# tumbllr-spin
--------------

This is an effort to replace the Arduino Nano in Elegoo's [Tumbllr balancing bot](https://www.elegoo.com/products/elegoo-tumbller-self-balancing-robot-car) with an equivalent Parallax Propeller/P8X32A-based board.

The goal is equivalent functionality

## Components
-------------

The basic software to interface with the following major components must first be implemented:

- [x] ultrasonic
- [x] motors `(motor.brushed.hbridge-pwm.spin)`
- [x] smart LEDs `(display.led.smart.spin)`
- [ ] IR TX `(TBD)`
- [ ] IR RX `(TBD)`
- [ ] BLE `(TBD)`
- [ ] IMU: MPU6050 `(TBD)`

## Projected cog usage
----------------------

* motors: driving (handled by motor.brushed.hbridge-pwm.spin)
* motors: encoders
* imu
* smart LEDs: handled by display.led.smart.spin

