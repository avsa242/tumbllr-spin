'xxx not functional - unable to talk to ble module...related to transistor Q1? (what is it for?)
'xxx on the nano, A2 outputs about 1.0v to the base. Doing the same from the Prop seems to have
'   no effect
'xxx RX idles low for some reason...

CON

    _clkmode= xtal1 + pll16x
    _xinfreq= 5_000_000

    BLE_TX  = 0
    BLE_RX  = 1
    BLE_BPS = 9600

OBJ

    ser: "com.serial.terminal.ansi"
    time: "time"
    ble: "com.serial.terminal"
    dac: "signal.dac.duty"

PUB main | b, ch

    dac.start(24, 0, 8)
    dac.output(0, 80)   ' about 1.0v
    ser.start(115200)
    time.msleep(20)
    ser.clear
    ser.strln(@"serial started")

    b := ble.init(BLE_RX, BLE_TX, 0, BLE_BPS)
    time.msleep(20)
    if (b)
        ser.strln(@"ble started")
    
'    ble.strln(@"AT+NAME?")
    repeat
'        repeat until ble.fifo_rx_bytes
        ch := ble.getchar
        if (ch)
            ser.puthexs(ch, 2)
            ser.putchar(" ")

