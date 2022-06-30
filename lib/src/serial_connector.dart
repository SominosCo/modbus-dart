import 'dart:async';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import '../modbus.dart';
import 'package:libserialport/libserialport.dart';
import 'acii_converter.dart';
import 'util.dart';
import 'crc.dart';

class SerialConnector extends ModbusConnector {
  String _port;
  SerialPort? _serial;
  late int _unitId;
  ModbusMode _mode;
  final Logger log = new Logger('RtuConnector');

  SerialConnector(this._port, this._mode) {
    _serial = SerialPort(this._port);
  }

  int configure(
    int baudRate,
    int dataBits,
    int parity,
    int stopBits,
    int flowControl,
  ) {
    if (_serial == null) {
      log.finest('ERROR: Serial port is null.');
      return -1;
    }
    if (_serial!.isOpen != true) {
      log.finest('ERROR: Serial port must be open before configuring.');
      return -1;
    }
    var configs = SerialPortConfig();
    _serial!.config.baudRate = baudRate;
    _serial!.config.parity = parity;
    _serial!.config.bits = dataBits; // data bits [5, 6, 7, 8]
    _serial!.config.stopBits = stopBits; //[1, 2]
    configs.setFlowControl(flowControl);
    return 0;
  }

  @override
  Future<bool> connect() {
    //throw UnimplementedError("NOT IMPLEMENTED");

    if (_serial?.openReadWrite() != true) {
      log.finest('ERROR: Error opening serial port @' + this._port);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void write(int function, Uint8List data) {
    throw UnimplementedError("NOT IMPLEMENTED");
  }

  @override
  Future<bool> close() {
    //throw UnimplementedError("NOT IMPLEMENTED");
    if (_serial?.close() != true) {
      log.finest('ERROR: Error closing serial port');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void setUnitId(int unitId) {
    //throw UnimplementedError("NOT IMPLEMENTED");
    if (unitId < 0 || unitId > 255) {
      log.finest('ERROR: UnitId of ' + unitId.toString() + ' is out of range');
      return;
    }
    _unitId = unitId;
  }

/**
 * callback if bytes are available 
 * TODO: Review, I copied from tcp
 */
  void _onData(List<int> rtuData) {
    if (_mode == ModbusMode.ascii) {
      rtuData = AsciiConverter.fromAscii(rtuData);
    }

    log.finest('RECV: ' + dumpHexToString(rtuData));
    var view = ByteData.view(Uint8List.fromList(rtuData).buffer);
    int tid = view.getUint16(0); // ignore: unused_local_variable
    int len = view.getUint16(4);
    int unitId = view.getUint8(6); // ignore: unused_local_variable
    int function = view.getUint8(7);

    onResponse(function,
        rtuData.sublist(8, 8 + len - 2 /*unitId + function*/) as Uint8List);
  }

  Uint8List _crc(Uint8List bytes) {
    var crc = BigInt.from(0xffff);
    var poly = BigInt.from(0xa001);

    for (var byte in bytes) {
      var bigByte = BigInt.from(byte);
      crc = crc ^ bigByte;
      for (int n = 0; n <= 7; n++) {
        int carry = crc.toInt() & 0x1;
        crc = crc >> 1;
        if (carry == 0x1) {
          crc = crc ^ poly;
        }
      }
    }
    //return crc.toUnsigned(16).toInt();
    var ret = Uint8List(2);
    ByteData.view(ret.buffer).setUint16(0, crc.toUnsigned(16).toInt());
    return ret;
  }
}
