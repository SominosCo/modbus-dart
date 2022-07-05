import 'dart:typed_data';

import 'package:logging/logging.dart';

import '../modbus.dart';

class AsciiConverter {
  static final Logger log = new Logger('AsciiConverter');

  /// Takes the data from a ASCII Modbus packet [tcpData] and translates it to integers,
  /// removes the CRLF bytes at the end of the packet and returns the raw
  /// integers converted from ASCII
  static Uint8List fromAscii(Uint8List tcpData) {
    String str = String.fromCharCodes(tcpData);
    log.finest('From ASCII: ' + str);
    if (str.length % 2 != 0)
      throw ModbusException("ASCII string is not even count");
    if (!str.endsWith(String.fromCharCodes([0x0d, 0xa])))
      throw ModbusException("Invalid ASCII received");
    List<int> ret = [];
    for (int i = 0; i < str.length - 2 /*without CRLF*/; i += 2) {
      ret.add(int.parse(str.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(ret);
  }

  /// Takes a byte list [data] in and removes the first bite assuming a ":" and sends
  /// the rest for processing in [fromAscii]. Returns the result from that
  /// function.
  static Uint8List fromAsciiWithHeader(Uint8List data) {
    return fromAscii(data.sublist(1));
  }

  /// Takes a list of [tcpData] and converts it to ascii and adds the closing
  /// characters to it 'CRLF'
  static Uint8List toAscii(Uint8List tcpData) {
    StringBuffer sb = StringBuffer();
    tcpData.forEach((d) {
      sb.write(d.toRadixString(16).padLeft(2, '0'));
    });
    sb.write(String.fromCharCodes([0x0d, 0xa]));
    String str = sb.toString();
    log.finest('to ASCII: ' + str);
    return Uint8List.fromList(str.codeUnits);
  }

  /// Takes a byte list [data] converts it to ascii and adds 'CRLF' commands to it
  /// and will then add ascii ':' to the front of it
  static Uint8List toAsciiWithHeader(Uint8List data) {
    return Uint8List.fromList([58] + toAscii(data));
  }
}
