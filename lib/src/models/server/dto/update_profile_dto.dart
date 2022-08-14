class UpdateProfileDto {
  final String? profileName;
  final String? callsign;

  final String? name;
  final int? dxcc;
  final int? cqZone;
  final int? ituZone;
  final String? gridsquare;

  final String? qth;
  final String? state;
  final String? country;

  const UpdateProfileDto({
    this.profileName,
    this.callsign,
    this.name,
    this.dxcc,
    this.cqZone,
    this.ituZone,
    this.gridsquare,
    this.qth,
    this.state,
    this.country,
  });

  Map<String, dynamic> toJson() => {
        if (profileName?.isNotEmpty == true) 'profile_name': profileName,
        if (callsign?.isNotEmpty == true) 'callsign': callsign,
        if (name?.isNotEmpty == true) 'name': name,
        if (dxcc != null) 'dxcc': dxcc,
        if (cqZone != null) 'cq_zone': cqZone,
        if (ituZone != null) 'itu_zone': ituZone,
        if (gridsquare?.isNotEmpty == true) 'gridsquare': gridsquare,
        if (qth?.isNotEmpty == true) 'qth': qth,
        if (state?.isNotEmpty == true) 'state': state,
        if (country?.isNotEmpty == true) 'country': country,
      };
}
