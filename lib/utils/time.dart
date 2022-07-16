String durationString(int duration) {
  final hours = duration ~/ (60 * 60);
  final minutes = duration % (60 * 60) ~/ 60;
  final seconds = duration % (60 * 60) % 60;

  final hoursStr = hours > 0 ? '${_timeStr(hours)}:' : '';
  final minutesStr = minutes > 0 ? '${_timeStr(minutes)}:' : '00:';
  final secondsStr = seconds > 0 ? _timeStr(seconds) : '00';

  return "$hoursStr$minutesStr$secondsStr";
}

String _timeStr(int number) {
  return number > 0
      ? number < 10
          ? '0$number'
          : '$number'
      : '';
}
