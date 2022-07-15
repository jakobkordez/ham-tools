class CabrilloQsoData {
  final String frequency;
  final String? mode;
  final String date;
  final String time;
  final String callsignSent;
  final List<String> exchangeSent;
  final String callsignRecieved;
  final List<String> exchangeRecieved;
  final int? transmitterId;

  const CabrilloQsoData({
    required this.frequency,
    this.mode,
    required this.date,
    required this.time,
    required this.callsignSent,
    this.exchangeSent = const [],
    required this.callsignRecieved,
    this.exchangeRecieved = const [],
    this.transmitterId,
  });
}
