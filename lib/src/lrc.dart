import 'dart:typed_data';

import 'byte.dart';

int modbusLRC(Uint8List data) {
  var nLRC = Byte();
  for (int i = 0; i < data.length; i++) {
    nLRC.set(nLRC.get() + data[i]);
    print(nLRC.get());
  }
  nLRC.set(-nLRC.get());
  print("FINAL:");
  print(nLRC.get());
  return nLRC.get();
}
