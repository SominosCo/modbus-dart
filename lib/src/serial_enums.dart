enum ModbusMode {
  rtu(0, "rtu"),
  ascii(1, "ascii");

  const ModbusMode(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Transmission Mode';
}

enum ModbusPortBuffer {
  input(1, "input"),
  output(2, "output"),
  both(3, "both");

  const ModbusPortBuffer(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Port Buffers';
}

enum ModbusBaudrate {
  baud_75(75, "75 bps"),
  baud_110(110, "110 bps"),
  baud_300(300, "300 bps"),
  baud_1200(1200, "1.2 kbps"),
  baud_2400(2400, "2.4 kbps"),
  baud_4800(4800, "4.8 kbps"),
  baud_9600(9600, "9.6 kbps"),
  baud_19200(19200, "19.2 kbps"),
  baud_38400(38400, "38.4 kbps"),
  baud_57600(57600, "57.6 kbps"),
  baud_115200(115200, "115.2 kbps");

  const ModbusBaudrate(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Baud Rate';
}

enum ModbusDataBits {
  bits_5(5, "5 bits"),
  bits_6(6, "6 bits"),
  bits_7(7, "7 bits"),
  bits_8(8, "8 bits");

  const ModbusDataBits(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Data Bits';
}

enum ModbusStopBits {
  stopBits_1(1, "1 Stop Bit"),
  stopBits_2(2, "2 Stop Bits");

  const ModbusStopBits(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Stop Bits';
}

enum ModbusCts {
  retain(-1, "Retain port setting"),
  ignore(0, "CTS unused"),
  flowControl(1, "CTS for flow control");

  const ModbusCts(this.value, this.description);
  final int value;
  final String description;
  final String label = 'CTS Mode';
}

enum ModbusDsr {
  retain(-1, "Retain port setting"),
  ignore(0, "DSR unused"),
  flowControl(1, "DSR for flow control");

  const ModbusDsr(this.value, this.description);
  final int value;
  final String description;
  final String label = 'DSR Mode';
}

enum ModbusDtr {
  retain(-1, "Retain port setting"),
  off(0, "off"),
  on(1, "on"),
  flowControl(2, "DTR for flow control");

  const ModbusDtr(this.value, this.description);
  final int value;
  final String description;
  final String label = 'DTR Mode';
}

enum ModbusRts {
  retain(-1, "Retain port setting"),
  off(0, "off"),
  on(1, "on"),
  flowControl(2, "RTS for flow control");

  const ModbusRts(this.value, this.description);
  final int value;
  final String description;
  final String label = 'RTS Mode';
}

enum ModbusFlowControl {
  none(0, "No flow control"),
  xonXoff(1, "Xon/Xoff flow control"),
  rtsCts(2, "RTS/CTS flow control"),
  dtrDsr(3, "DTR/DSR flow control");

  const ModbusFlowControl(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Flow Control';
}

enum ModbusPortMode {
  read(1, "read"),
  write(2, "write"),
  readWrite(3, "read-write");

  const ModbusPortMode(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Serial Port Open Mode';
}

enum ModbusParity {
  none(0, "none"),
  odd(1, "odd"),
  even(2, "even"),
  mark(3, "mark"),
  space(4, "space");

  const ModbusParity(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Parity';
}

enum ModbusPortSignal {
  cts(1, 'cts', "clear-to-send"),
  dsr(2, 'dsr', "data-set-ready"),
  dcd(4, 'dcd', "data-carrier-detect"),
  ri(8, 'ri', "ring-indicator");

  const ModbusPortSignal(this.value, this.name, this.description);
  final int value;
  final String name;
  final String description;
  final String label = 'Serial Port Signal';
}

enum ModbusPortTransport {
  native(0, "native"),
  usb(1, "usb"),
  bluetooth(2, "bluetooth");

  const ModbusPortTransport(this.value, this.description);
  final int value;
  final String description;
  final String label = 'Transport';
}

enum ModbusXonXoff {
  disabled(0, "disabled"),
  input(1, "input"),
  output(2, "output"),
  inOut(3, "in-out");

  const ModbusXonXoff(this.value, this.description);
  final int value;
  final String description;
  final String label = 'XonXoff';
}
