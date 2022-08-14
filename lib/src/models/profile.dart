import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String? id;
  final String? owner;

  final String profileName;
  final String callsign;

  final String? name;
  final int? dxcc;
  final int? cqZone;
  final int? ituZone;
  final String? gridsquare;

  final String? qth;
  final String? state;
  final String? country;

  const Profile({
    this.id,
    this.owner,
    required this.profileName,
    required this.callsign,
    this.name,
    this.dxcc,
    this.cqZone,
    this.ituZone,
    this.gridsquare,
    this.qth,
    this.state,
    this.country,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileName: json['profile_name'],
        callsign: json['callsign'],
        name: json['name'],
        dxcc: json['dxcc'],
        cqZone: json['cq_zone'],
        ituZone: json['itu_zone'],
        gridsquare: json['gridsquare'],
        qth: json['qth'],
        state: json['state'],
        country: json['country'],
      );

  Map<String, dynamic> toJson() => {
        'profile_name': profileName,
        'callsign': callsign,
        if (name != null) 'name': name,
        if (dxcc != null) 'dxcc': dxcc,
        if (cqZone != null) 'cq_zone': cqZone,
        if (ituZone != null) 'itu_zone': ituZone,
        if (gridsquare != null) 'gridsquare': gridsquare,
        if (qth != null) 'qth': qth,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
      };

  @override
  List<Object?> get props => [
        id,
        owner,
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
