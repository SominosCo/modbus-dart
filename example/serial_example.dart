import 'package:libserialport/libserialport.dart';
import 'package:modbus/modbus.dart' as modbus;
import 'package:modbus/src/modbus_enums.dart';
import 'dart:io';

void serialExample() async {
  //var result = await Process.run(
  //  'setx',
  //  [
  //    "LIBSERIALPORT_PATH C:\Users\Tom\Documents\workspaces\modbus-dart\windows\resources\serialport.dll"
  //  ],
  //  includeParentEnvironment: true,
  //);
  //print(result);
  print('Available ports:');
  var i = 0;
  for (final name in SerialPort.availablePorts) {
    final sp = SerialPort(name);
    print('${++i}) $name');
    print('\tDescription: ${sp.description}');
    print('\tManufacturer: ${sp.manufacturer}');
    print('\tSerial Number: ${sp.serialNumber}');
    print('\tProduct ID: 0x${sp.productId?.toRadixString(16)}');
    print('\tVendor ID: 0x${sp.vendorId?.toRadixString(16)}');
    sp.dispose();
  }

  modbus.ModbusClient? client;
  try {
    client = modbus.createRtuClient(
      'COM4',
      ModbusBaudrate.fromInt(9600),
      dataBits: ModbusDataBits.fromInt(8),
      mode: ModbusMode.rtu,
      parity: ModbusParity.none,
      stopBits: ModbusStopBits.stopBits_1,
      unitId: 1,
    );
  } catch (e) {
    // handle process exception
    print('Exception caught: $e');
  }

  if (client != null) {
    try {
      //await client.connect();

      var slaveIdResponse = await client.reportSlaveId();

      StringBuffer sb = StringBuffer();
      slaveIdResponse.forEach((f) {
        sb.write(f.toRadixString(16).padLeft(2, '0'));
        sb.write(" ");
      });
      print("Slave ID: " + sb.toString());

      var exceptions = await client.readExceptionStatus();

      print("Exceptions: " + exceptions.toRadixString(2));

      {
        var registers = await client.readInputRegisters(0x0002, 6);
        for (int i = 0; i < registers.length; i++) {
          print("REG_I[${i}]: " + registers.elementAt(i).toString());
        }
      }
    } finally {
      client.close();
    }
  }
}
