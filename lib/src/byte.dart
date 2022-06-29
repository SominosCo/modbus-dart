import 'dart:typed_data';

class Byte {
  // this should extend int but it looks like its not allowed
  var buf = ByteData(1);

  Byte() {
    buf.setUint8(0, 0);
  }

  // named constructors?
  //Byte(int val) {
  //  buf.setUint8(0, val);
  //}

  //Byte(Byte other) {
  //  this = other;
  //}

  void set(int val) {
    buf.setUint8(0, val);
  }

  int get() {
    return buf.getUint8(0);
  }

  @override
  String toString() {
    return buf.getUint8(0).toRadixString(2);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is int && other == buf.getUint8(0);
  }

  Byte operator +(int val) {
    Byte rtn = this;
    rtn.set(buf.getUint8(0) + val);
    return rtn;
  }

  //Byte operator +(Byte other) {
  //  Byte rtn = this;
  //  rtn.set(buf.getUint8(0) + other.get());
  //  return rtn;
  //}

  Byte operator -(int val) {
    Byte rtn = this;
    rtn.set(buf.getUint8(0) - val);
    return rtn;
  }

  //Byte operator -(Byte other) {
  //  Byte rtn = this;
  //  rtn.set(buf.getUint8(0) - other.get());
  //  return rtn;
  //}

  String toHex() {
    String hex = buf.getUint8(0).toRadixString(16).padLeft(2, '0');
    hex = "0x" + hex;
    return hex;
  }

  @override
  int get hashCode {
    return buf.getUint8(0).hashCode;
  }
}
