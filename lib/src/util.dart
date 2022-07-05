String dumpHexToString(List<int> data) {
  StringBuffer sb = StringBuffer();
  sb.write("[ ");
  data.forEach((f) {
    sb.write("0x" + f.toRadixString(16).padLeft(2, '0') + " ");
  });
  sb.write("]");
  return sb.toString();
}
