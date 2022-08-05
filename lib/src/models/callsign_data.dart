import 'dxcc_entity.dart';

class CallsignData {
  static final callsignRegex = RegExp(
    r'^([A-Z\d]{1,4}\/)?([A-Z\d]{1,3}\d+[A-Z]+)((\/[A-Z\d]+)*)$',
    caseSensitive: false,
  );
  static final _replaceRegex = RegExp(r'[^A-Z0-9/]+', caseSensitive: false);

  final bool isValid;
  final String callsign;
  final int? prefixLength;
  final String? secPrefix;
  final List<SecondarySuffix> secSuffixes;
  final DxccEntity? prefixDxcc;
  final DxccEntity? secPrefixDxcc;

  CallsignData._({
    required this.isValid,
    required this.callsign,
    this.prefixLength,
    this.secPrefix,
    this.secSuffixes = const [],
    this.prefixDxcc,
    this.secPrefixDxcc,
  });

  static bool isValidCallsign(String callsign) =>
      callsignRegex.hasMatch(callsign);

  factory CallsignData.parse(String callsign) {
    callsign = callsign.toUpperCase().replaceAll(_replaceRegex, '');
    final regMatch = callsignRegex.firstMatch(callsign);

    if (regMatch == null) {
      final dxcc = DxccEntity.findSub(callsign);

      return CallsignData._(
        isValid: false,
        callsign: callsign,
        prefixDxcc: dxcc,
        prefixLength: dxcc?.prefixRe.matchAsPrefix(callsign)?.end,
      );
    }

    var secPrefix = regMatch.group(1);
    if (secPrefix != null) {
      callsign = callsign.substring(secPrefix.length);
      secPrefix = secPrefix.substring(0, secPrefix.length - 1);
    }

    final dxcc = DxccEntity.findSub(callsign);
    final prefixLength = dxcc?.prefixRe.matchAsPrefix(callsign)?.end;

    final pfx = callsign.substring(0, prefixLength ?? 0);
    Iterable<String> secSuffixes;
    if (pfx.contains('/')) {
      secSuffixes = callsign.substring(prefixLength ?? 0).split('/').skip(1);
      callsign = callsign.substring(0, prefixLength ?? 0);
    } else {
      secSuffixes = regMatch.group(3)!.split('/').skip(1);
      callsign = regMatch.group(2)!;
    }

    return CallsignData._(
      isValid: true,
      callsign: callsign,
      prefixLength: prefixLength,
      prefixDxcc: dxcc,
      secPrefixDxcc: secPrefix != null ? DxccEntity.findSub(secPrefix) : null,
      secPrefix: secPrefix,
      secSuffixes: secSuffixes.map((e) => SecondarySuffix.parse(e)).toList(),
    );
  }
}

class SecondarySuffix {
  static const portable = SecondarySuffix._('P', 'Portable');
  static const lowPower = SecondarySuffix._('QRP', 'Low Power');
  static const mobile = SecondarySuffix._('M', 'Mobile');
  static const maritimeMobile = SecondarySuffix._('MM', 'Maritime Mobile');
  static const aeroMobile = SecondarySuffix._('AM', 'Aeronautical Mobile');
  static const alternative = SecondarySuffix._('A', 'Alternative location');

  static const values = [
    portable,
    lowPower,
    mobile,
    maritimeMobile,
    aeroMobile,
    alternative,
  ];

  static SecondarySuffix parse(String value) {
    value = value.toUpperCase();

    for (final v in values) {
      if (v.suffix == value) {
        return v;
      }
    }

    if (RegExp(r'^\d$').hasMatch(value)) {
      return SecondarySuffix._(
          value, 'Own call area, away from primary location');
    }

    return SecondarySuffix._(value, 'Away from primary location');
  }

  final String suffix;
  final String description;

  const SecondarySuffix._(this.suffix, this.description);
}
