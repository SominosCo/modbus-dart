import 'dart:async';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:modbus/src/lrc.dart';
import '../modbus.dart';
import 'package:libserialport/libserialport.dart';
import 'ascii_converter.dart';
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
    connect();
  }

  bool get isAscii => _mode == ModbusMode.ascii;

  int configure(
    ModbusBaudrate baudRate,
    ModbusDataBits dataBits,
    ModbusParity parity,
    ModbusStopBits stopBits,
    ModbusFlowControl flowControl,
  ) {
    if (_serial == null) {
      log.severe('ERROR: Serial port is null.');
      return -1;
    }
    if (_serial!.isOpen != true) {
      log.severe('ERROR: Serial port must be open before configuring.');
      return -1;
    }
    _serial!.config.baudRate = baudRate.value;
    _serial!.config.parity = parity.value;
    _serial!.config.bits = dataBits.value; // data bits [5, 6, 7, 8]
    _serial!.config.stopBits = stopBits.value; //[1, 2]
    _serial!.config.setFlowControl(flowControl.value);
    return 0;
  }

  @override
  Future<bool> connect() {
    if (_serial == null) {
      log.severe('ERROR: Serial port is null.');
      return Future.value(false);
    }

    if (_serial!.isOpen) {
      log.finest('Serial port is already connected.');
      return Future.value(true);
    }

    if (_serial!.openReadWrite() != true) {
      log.severe('ERROR: Error opening serial port @' +
          this._port +
          ". Error: " +
          SerialPort.lastError.toString());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void write(int function, Uint8List data) {
    if (_serial == null) {
      log.severe('ERROR: Serial port is null.');
      return;
    }
    if (_serial!.isOpen != true) {
      log.severe('ERROR: Serial port must be open to write.');
      return;
    }
    // data size: function + address + data length + crc(lrc)
    var tx_data = ByteData(1 + 1 + data.lengthInBytes + (isAscii ? 1 : 2));
    int i = 0;
    tx_data.setUint8(i++, _unitId);
    tx_data.setUint8(i++, function);
    data.map((e) => tx_data.setUint8(i++, e));
    if (isAscii) {
      tx_data.setUint8(i++, modbusLRC(tx_data.buffer.asUint8List()));
    } else {
      var crc = modbusCRC(tx_data.buffer).asUint8List();
      tx_data.setUint8(i++, crc[0]);
      tx_data.setUint8(i++, crc[1]);
    }
    if (isAscii)
      _serial!.write(
          AsciiConverter.toAsciiWithHeader(tx_data.buffer.asUint8List()));
    else {
      log.finest(dumpHexToString(tx_data.buffer.asUint8List()));
      _serial!.write(tx_data.buffer.asUint8List());
    }
  }

  @override
  Future<bool> close() {
    //throw UnimplementedError("NOT IMPLEMENTED");
    if (_serial?.close() != true) {
      log.severe('ERROR: Error closing serial port');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void setUnitId(int unitId) {
    //throw UnimplementedError("NOT IMPLEMENTED");
    if (unitId < 0 || unitId > 255) {
      log.severe('ERROR: UnitId of ' + unitId.toString() + ' is out of range');
      return;
    }
    _unitId = unitId;
  }

/**
 * callback if bytes are available 
 * TODO: Review, I copied from tcp
 */
  void _onData(Uint8List rtuData) {
    if (_mode == ModbusMode.ascii) {
      rtuData = AsciiConverter.fromAscii(rtuData);
    }

    log.finest('RECV: ' + dumpHexToString(rtuData));
    var view = ByteData.view(rtuData.buffer);
    int tid = view.getUint16(0); // ignore: unused_local_variable
    int len = view.getUint16(4);
    int unitId = view.getUint8(6); // ignore: unused_local_variable
    int function = view.getUint8(7);

    onResponse(function, rtuData.sublist(8, 8 + len - 2 /*unitId + function*/));
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
