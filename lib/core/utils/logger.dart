import 'package:logger/logger.dart';

class Log {
  final Logger _logger;
  static final Log _instance = Log._internal();

  static final Logger instanceLongLine = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      lineLength: 300,
    ),
  );

  factory Log() {
    return _instance;
  }

  Log._internal()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            lineLength: 20,
          ),
        );

  Logger get logger => _logger;
}

Logger get logger => Log().logger;
Logger get loggerInfinity => Log.instanceLongLine;