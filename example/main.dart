import 'package:modbus/modbus.dart' as modbus;
import 'package:logging/logging.dart';

import 'tcp_example.dart';
import 'serial_example.dart';

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time} [${rec.loggerName}]: ${rec.message}');
  });

  if (arguments.contains("-serial")) {
    serialExample();
  } else /* (arguments.contains("-tcp")) */ {
    tcpExample();
  }
}
