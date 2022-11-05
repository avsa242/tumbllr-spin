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

    imu.accel_data_rate(200)
    imu.accel_scale(2)
    imu.accel_axis_ena(%111)
    imu.gyro_scale(500)
    imu.gyro_axis_ena(%111)
    ser.printf1(@"accel scale: %d\n\r", imu.accel_scale(-2))
    ser.printf1(@"gyro scale: %d\n\r", imu.gyro_scale(-2))

    repeat
        imu.accel_data(@ax, @ay, @az)
        imu.gyro_data(@gx, @gy, @gz)
        ser.pos_xy(0, 10)
        ser.printf3(@"x: %06.6d  y: %06.6d  z: %06.6d\n\r", ax, ay, az)
        ser.printf3(@"x: %06.6d  y: %06.6d  z: %06.6d", gx, gy, gz)

    repeat

