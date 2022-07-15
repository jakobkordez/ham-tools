part of 'stats_cubit.dart';

enum StatsStateStatus { initial, loading, loaded, error }

class StatsState extends Equatable {
  final StatsStateStatus status;
  final String lotwUsername;
  final String lotwPassword;
  final String adi;
  final Key adiKey;
  final QsoStats? qsoStats;
  final String? error;

  StatsState({
    this.status = StatsStateStatus.initial,
    this.lotwUsername = '',
    this.lotwPassword = '',
    this.adi = '',
    Key? adiKey,
    this.qsoStats,
    this.error,
  }) : adiKey = adiKey ?? UniqueKey();

  StatsState copyWith({
    StatsStateStatus? status,
    String? lotwUsername,
    String? lotwPassword,
    String? adi,
    bool updateAdi = false,
    QsoStats? qsoStats,
    String? error,
  }) =>
      StatsState(
        lotwUsername: lotwUsername ?? this.lotwUsername,
        lotwPassword: lotwPassword ?? this.lotwPassword,
        adi: adi ?? this.adi,
        adiKey: updateAdi ? null : adiKey,
        qsoStats: qsoStats ?? this.qsoStats,
        error: (status ?? this.status) == StatsStateStatus.error
            ? (error ?? this.error)
            : null,
      );

  @override
  List<Object?> get props =>
      [status, lotwUsername, lotwPassword, adi, adiKey, qsoStats, error];
}
