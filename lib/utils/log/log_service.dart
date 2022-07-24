import 'dart:developer' as devlog;

import 'package:flutter/foundation.dart';
import 'log_status.dart';

LogStatus? _status;

abstract class LogService {
  static void log(String message, {Exception? exception, Object? errorObject, bool debug = false}) {
    if (_status == null) {
      _status = getLogStatus();
    }

    var output = '''
--------------------------------------------------------
${DateTime.now().toUtc()} $message\n''';

    if (exception != null) {
      output += 'Exception: ${exception.toString()}\n';
    }

    if (errorObject != null) {
      output += 'Error: ${errorObject.toString()}\n';
    }

    output += '--------------------------------------------------------';
    if (_status != null && _status!.isDebug == true) {
      kIsWeb ? debugPrint(output) : devlog.log(output);
    }
    if (!kReleaseMode) {
      kIsWeb ? debugPrint(output) : devlog.log(output);
    } else if (!kIsWeb) {
      log(output);
    }
  }

  static void recordFlutterError(FlutterErrorDetails err) {
    if (!kReleaseMode) {
      kIsWeb ? debugPrint(err.exception.toString()) : devlog.log(err.exception.toString());
    } else if (!kIsWeb) {
      log(err.exception.toString());
    }
  }
}