part of 'new_log_entry_cubit.dart';

class NewLogEntryState extends LogEntry {
  final bool split;
  final bool hasTimeOff;

  NewLogEntryState({
    String callsign = '',
    DateTime? timeOn,
    DateTime? timeOff,
    int frequency = 7000000,
    int? frequencyRx,
    Mode mode = Mode.ssb,
    String rstSent = '',
    String rstReceived = '',
    Band? band,
    Band? bandRx,
    this.split = false,
    this.hasTimeOff = false,
    String name = '',
    String notes = '',
    int? power,
  }) : super(
          callsign: callsign,
          timeOn: timeOn ?? DateTime.now(),
          timeOff: hasTimeOff ? timeOff : null,
          frequency: frequency,
          frequencyRx: split ? frequencyRx : null,
          mode: mode,
          rstSent: rstSent,
          rstReceived: rstReceived,
          name: name,
          notes: notes,
          power: power,
        );

  NewLogEntryState copyWith({
    String? callsign,
    DateTime? timeOn,
    DateTime? timeOff,
    int? frequency,
    int? frequencyRx,
    Mode? mode,
    String? rstSent,
    String? rstReceived,
    bool? split,
    bool? hasTimeOff,
    String? name,
    String? notes,
    int? power,
  }) =>
      NewLogEntryState(
        callsign: callsign ?? this.callsign,
        timeOn: timeOn ?? this.timeOn,
        timeOff: timeOff ?? this.timeOff,
        frequency: frequency ?? this.frequency,
        frequencyRx: frequencyRx ?? this.frequencyRx,
        mode: mode ?? this.mode,
        rstSent: rstSent ?? this.rstSent,
        rstReceived: rstReceived ?? this.rstReceived,
        split: split ?? this.split,
        hasTimeOff: hasTimeOff ?? this.hasTimeOff,
        name: name ?? this.name,
        notes: notes ?? this.notes,
        power: power == null ? this.power : (power < 0 ? null : power),
      );

  @override
  List<Object?> get props => [...super.props, split, hasTimeOff];
}
