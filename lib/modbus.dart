import 'dart:async';
import 'dart:typed_data';

import 'src/modbus_enums.dart';
import 'src/client.dart';
import 'src/tcp_connector.dart';
import 'src/serial_connector.dart';
export 'src/tcp_connector.dart';
export 'src/serial_connector.dart';
export 'src/exceptions.dart';
export 'src/modbus_enums.dart';

typedef void FunctionCallback(int function, Uint8List data);
typedef void ErrorCallback(dynamic error, dynamic stackTrace);
typedef void CloseCallback();

/// MODBUS Connector.
abstract class ModbusConnector {
  /// Connect will be called from the [ModbusClient] to establish connection
  Future connect();

  /// Will be called from the [ModbusClientImpl]
  Future close();

  /// Set unit ID
  void setUnitId(int unitId);

  /// Write function with data over connector. Will be called from the [ModbusClientImpl]
  void write(int function, Uint8List data);

  /// This should be called by the Connector implementation when response comes from the device
  late FunctionCallback onResponse;

  /// This should be called by the Connector implementation when any error occurs
  ErrorCallback? onError;

  /// This should be called by the Connector implementation after closing connection (socket close, etc)
  CloseCallback? onClose;
}

/// MODBUS client
abstract class ModbusClient {
  Future<void> connect();

  Future<void> close();

  /// Set unit ID for the next call
  void setUnitId(int unitId);

  /// Execute custom modbus function
  Future<Uint8List> executeFunction(int function, [Uint8List? data]);

  /// Report slave ID, function 0x11
  Future<Uint8List> reportSlaveId();

  /// Read exception status, function 0x07
  Future<int> readExceptionStatus();

  /// Read coils, function 0x01
  Future<List<bool?>> readCoils(int address, int amount);

  /// Read discrete inputs, function 0x02
  Future<List<bool?>> readDiscreteInputs(int address, int amount);

  /// Read holding registers, function 0x03
  Future<Uint16List> readHoldingRegisters(int address, int amount);

  /// Read input registers, function 0x04
  Future<Uint16List> readInputRegisters(int address, int amount);

  /// Write single coil, function 0x05
  Future<bool> writeSingleCoil(int address, bool to_write);

  /// Write single register, function 0x06
  Future<int> writeSingleRegister(int address, int value);

  /// Write multiply coils, function 0x0f
  Future<void> writeMultipleCoils(int address, List<bool> values);

  /// Write multiply registers, function 0x10
  Future<void> writeMultipleRegisters(int address, Uint16List values);
}

ModbusClient createClient(TcpConnector connector, {int unitId = 1}) =>
    ModbusClientImpl(connector, unitId);

ModbusClient createTcpClient(dynamic address,
        {int port = 502, ModbusMode mode = ModbusMode.rtu, int unitId = 1}) =>
    ModbusClientImpl(TcpConnector(address, port, mode), unitId);

ModbusClient createRtuClient(String port, ModbusBaudrate baudRate,
    {ModbusDataBits dataBits = ModbusDataBits.bits_8,
    ModbusParity parity = ModbusParity.none,
    ModbusStopBits stopBits = ModbusStopBits.stopBits_1,
    ModbusFlowControl flowControl = ModbusFlowControl.none,
    ModbusMode mode = ModbusMode.rtu,
    int unitId = 1}) {
  var serial = SerialConnector(port, mode);
  serial.configure(
    baudRate,
    dataBits,
    parity,
    stopBits,
    flowControl,
  );
  ModbusClient rtn = ModbusClientImpl(serial, unitId);

  return rtn;
}
