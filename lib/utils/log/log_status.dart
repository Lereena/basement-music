import 'log_status_base.dart' if (dart.library.io) 'log_status_io.dart' if (dart.library.html) 'log_status_html.dart';

class LogStatus {
  bool isDebug = false;
}

LogStatus getLogStatus() {
  final status = LogStatus();
  signUp((res) => {status.isDebug = res});
  return status;
}
