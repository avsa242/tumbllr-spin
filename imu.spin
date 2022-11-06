CON

    _clkmode    = xtal1 + pll16x
    _xinfreq    = 5_000_000

    I2C_SCL     = 28
    I2C_SDA     = 29
    I2C_HZ      = 400_000
    ADDR_BITS   = 0

OBJ

    ser: "com.serial.terminal.ansi"
    time: "time"
    imu: "sensor.imu.6dof.mpu6050"

PUB main | gx, gy, gz, ax, ay, az

    ser.start(115200)
    time.msleep(20)
    ser.clear

    if (imu.startx(I2C_SCL, I2C_SDA, I2C_HZ, ADDR_BITS))
        ser.strln(@"imu started")
        ser.printf1(@"devid: %02.2x\n\r", imu.dev_id{})
        imu.preset_active{}
        imu.clock_src(1)
        imu.sleep(0)
    else
        ser.strln(@"imu failed to start")
        repeat

    ser.printf1(@"accel scale: %d\n\r", imu.accel_scale(-2))
    ser.printf1(@"gyro scale: %d\n\r", imu.gyro_scale(-2))

    ser.strln(@"press a key to calibrate (hold level)")

    ser.getchar()
    imu.calibrate_accel()
    ser.strln(@"accel done")
    imu.calibrate_gyro()
    ser.strln(@"gyro done")

    repeat
'        imu.accel_g(@ax, @ay, @az)
'        imu.gyro_dps(@gx, @gy, @gz)
        imu.accel_data_cache()
        ser.pos_xy(0, 10)
'        ser.printf3(@"x: %07.7d  y: %07.7d  z: %07.7d\n\r", ax, ay, az)
'        ser.printf3(@"x: %06.6d  y: %06.6d  z: %06.6d", gx, gy, gz)
        ser.printf2(@"pitch: %5.5d  roll: %5.5d\n\r", imu.pitch(), imu.roll())
    repeat

