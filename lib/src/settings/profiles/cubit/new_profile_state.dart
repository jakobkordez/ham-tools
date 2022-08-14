part of 'new_profile_cubit.dart';

class NewProfileState extends Equatable {
  final String profileName;
  final String callsign;
  final String name;
  final String dxcc;
  final String cqZone;
  final String ituZone;
  final String gridsquare;
  final String qth;
  final String state;
  final String country;

  const NewProfileState({
    this.profileName = '',
    this.callsign = '',
    this.name = '',
    this.dxcc = '',
    this.cqZone = '',
    this.ituZone = '',
    this.gridsquare = '',
    this.qth = '',
    this.state = '',
    this.country = '',
  });

  DxccEntity? get dxccEntity =>
      DxccEntity.dxccs.firstWhereOrNull((e) => e.dxcc == int.tryParse(dxcc));

  NewProfileState copyWith({
    String? profileName,
    String? callsign,
    String? name,
    String? dxcc,
    DxccEntity? dxccEntity,
    String? cqZone,
    String? ituZone,
    String? gridsquare,
    String? qth,
    String? state,
    String? country,
  }) =>
      NewProfileState(
        profileName: profileName ?? this.profileName,
        callsign: callsign ?? this.callsign,
        name: name ?? this.name,
        dxcc: dxcc ?? '${dxccEntity?.dxcc ?? this.dxcc}',
        cqZone: cqZone ?? this.cqZone,
        ituZone: ituZone ?? this.ituZone,
        gridsquare: gridsquare ?? this.gridsquare,
        qth: qth ?? this.qth,
        state: state ?? this.state,
        country: country ?? this.country,
      );

  CreateProfileDto toCreateProfile() => CreateProfileDto(
        profileName: profileName,
        callsign: callsign,
        name: name.isNotEmpty ? name : null,
        dxcc: int.tryParse(dxcc),
        cqZone: int.tryParse(cqZone),
        ituZone: int.tryParse(ituZone),
        gridsquare: gridsquare.isNotEmpty ? gridsquare : null,
        qth: qth.isNotEmpty ? qth : null,
        state: state.isNotEmpty ? state : null,
        country: country.isNotEmpty ? country : null,
      );

  @override
  List<Object?> get props => [
        profileName,
        callsign,
        name,
        dxcc,
        cqZone,
        ituZone,
        gridsquare,
        qth,
        state,
        country,
      ];
}
