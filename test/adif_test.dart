import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/utils/adif.dart';

void main() {
  test('tryDecodeAdi', () {
    final adi = Adif.tryDecodeAdi(adiInput);

    expect(adi, adiMapList);
  });

  test('endodeAdi', () {
    final adiString = Adif.encodeAdi(adiMapList);

    expect(adiString, adiOutput);
  });
}

const adiMapList = [
  {
    'band': '40m',
    'band_rx': '40m',
    'call': 'II9WRTC',
    'freq': '7.119',
    'freq_rx': '7.119',
    'gridsquare': 'JN62ks',
    'mode': 'SSB',
    'my_name': 'Jakob Kordež',
    'name': 'WRTC 2022 Award S.E.S.',
    'qso_date': '20220123',
    'rst_rcvd': '59',
    'rst_sent': '59',
    'station_callsign': 'S52KJ',
    'time_on': '1642',
    'tx_pwr': '10',
  },
  {
    'band': '20m',
    'band_rx': '20m',
    'call': 'S57DX',
    'freq': '14.27',
    'freq_rx': '14.27',
    'mode': 'SSB',
    'qso_date': '20220123',
    'rst_rcvd': '59',
    'rst_sent': '59',
    'station_callsign': 'S52KJ',
    'time_on': '1651',
    'tx_pwr': '10',
  }
];

const adiOutput =
    r'<band:3>40m<band_rx:3>40m<call:7>II9WRTC<freq:5>7.119<freq_rx:5>7.119<gridsquare:6>JN62ks<mode:3>SSB<my_name:13>Jakob Kordež<name:22>WRTC 2022 Award S.E.S.<qso_date:8>20220123<rst_rcvd:2>59<rst_sent:2>59<station_callsign:5>S52KJ<time_on:4>1642<tx_pwr:2>10<eor><band:3>20m<band_rx:3>20m<call:5>S57DX<freq:5>14.27<freq_rx:5>14.27<mode:3>SSB<qso_date:8>20220123<rst_rcvd:2>59<rst_sent:2>59<station_callsign:5>S52KJ<time_on:4>1651<tx_pwr:2>10<eor>';

const adiInput = r'''
QRZLogbook download for s52kj
    Date: Tue Jan 25 19:45:06 2022
    Bookid: 318643
    Records: 12
    <ADIF_VER:5>3.1.1
    <PROGRAMID:10>QRZLogbook
    <PROGRAMVERSION:3>2.0
    <eoh>
<band:3>40m
<band_rx:3>40m
<call:7>II9WRTC
<freq:5>7.119
<freq_rx:5>7.119
<gridsquare:6>JN62ks
<mode:3>SSB
<my_name:13>Jakob Kordež
<name:22>WRTC 2022 Award S.E.S.
<qso_date:8>20220123
<rst_rcvd:2>59
<rst_sent:2>59
<station_callsign:5>S52KJ
<time_on:4>1642
<tx_pwr:2>10
<eor>

<band:3>20m
<band_rx:3>20m
<call:5>S57DX
<freq:5>14.27
<freq_rx:5>14.27
<mode:3>SSB
<qso_date:8>20220123
<rst_rcvd:2>59
<rst_sent:2>59
<station_callsign:5>S52KJ
<time_on:4>1651
<tx_pwr:2>10
<eor>
''';
