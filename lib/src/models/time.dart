class Time {
  final int hour;
  final int minute;
  final int second;
  final int millisecond;

  Time({
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.millisecond = 0,
  });

  String hhmmss() =>
      '${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}${second.toString().padLeft(2, '0')}';

  factory Time.fromMilliseconds(int ms) {
    final msec = ms % 1000;
    ms ~/= 1000;
    final sec = ms % 60;
    ms ~/= 60;
    final min = ms % 60;
    ms ~/= 60;
    return Time(
      hour: ms,
      minute: min,
      second: sec,
      millisecond: msec,
    );
  }
}
