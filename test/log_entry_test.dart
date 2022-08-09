import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/log_entry.dart';

void main() {
  group('fromAdiMap', () {
    test('minimum with freq', () {
      final entry = LogEntry.fromAdiMap(const {
        'CALL': 'S52KJ',
        'FREQ': '14.1234',
        'QSO_DATE': '20220208',
        'TIME_ON': '1245',
        'MODE': 'SSB',
      });

      expect(entry.callsign, 'S52KJ');
      expect(entry.frequency, 14123400);
      expect(entry.band, Band.hf20m);
      expect(entry.timeOn, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.timeOff, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.mode, Mode.ssb);
    });

    test('minimum with band', () {
      final entry = LogEntry.fromAdiMap(const {
        'CALL': 's52kj',
        'BAND': '20M',
        'QSO_DATE': '20220208',
        'TIME_ON': '1245',
        'MODE': 'ssb',
      });

      expect(entry.callsign, 'S52KJ');
      expect(entry.frequency, Band.hf20m.lowerBound);
      expect(entry.band, Band.hf20m);
      expect(entry.timeOn, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.timeOff, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.mode, Mode.ssb);
    });

    test('lowercase', () {
      final entry = LogEntry.fromAdiMap(const {
        'call': 's52kj',
        'band': '20M',
        'qso_date': '20220208',
        'time_on': '1245',
        'mode': 'ssb',
      });

      expect(entry.callsign, 'S52KJ');
      expect(entry.frequency, Band.hf20m.lowerBound);
      expect(entry.band, Band.hf20m);
      expect(entry.timeOn, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.timeOff, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.mode, Mode.ssb);
    });

    test('full', () {
      final entry = LogEntry.fromAdiMap(
        _fullRecord,
        id: '123',
        createdAt: DateTime.utc(2022, 01, 02, 03, 04),
        ownerId: 'owner1',
      );

      expect(entry.band, Band.hf40m);
      expect(entry.bandRx, Band.hf20m);
      expect(entry.callsign, 'EA9PD');
      expect(entry.frequency, 7074000);
      expect(entry.frequencyRx, 14074000);
      expect(entry.gridsquare, 'IM75iv');
      expect(entry.mode, Mode.ft8);
      expect(entry.subMode, isNull);
      expect(entry.timeOn, DateTime.utc(2022, 08, 07, 19, 52));
      expect(entry.timeOff, DateTime.utc(2022, 08, 08, 18, 58));
      expect(entry.name, 'PEDRO GUTIERREZ GUERRA');
      expect(entry.stationCall, 'S52KJ');
      expect(entry.operatorCall, isNull);
      expect(entry.power, 20);
      expect(entry.rstSent, '-13');
      expect(entry.rstReceived, '-10');
      expect(entry.comment, 'This is a comment');
      expect(entry.id, '123');
      expect(entry.createdAt, DateTime.utc(2022, 01, 02, 03, 04));
      expect(entry.ownerId, 'owner1');
    });
  });
}

const _fullRecord = {
  'APP_QRZLOG_LOGID': '797563228',
  'APP_QRZLOG_STATUS': 'N',
  'BAND': '40m',
  'BAND_RX': '20m',
  'CALL': 'EA9PD',
  'CONT': 'AF',
  'COUNTRY': 'Ceuta and Melilla',
  'DISTANCE': '1988',
  'DXCC': '32',
  'EMAIL': 'ea9pd@hotmail.com',
  'EQSL_QSL_RCVD': 'N',
  'EQSL_QSL_SENT': 'N',
  'FREQ': '7.074',
  'FREQ_RX': '14.074',
  'GRIDSQUARE': 'IM75iv',
  'LAT': 'N035 53.750',
  'LON': 'W005 17.500',
  'LOTW_QSL_RCVD': 'N',
  'LOTW_QSL_SENT': 'N',
  'MODE': 'FT8',
  'MY_CITY': 'Polhov Gradec',
  'MY_COUNTRY': 'Slovenia',
  'MY_CQ_ZONE': '15',
  'MY_GRIDSQUARE': 'JN76db',
  'MY_ITU_ZONE': '28',
  'MY_LAT': 'N046 03.848',
  'MY_LON': 'E014 18.604',
  'MY_NAME': 'Jakob Kordež',
  'NAME': 'PEDRO GUTIERREZ GUERRA',
  'QRZCOM_QSO_UPLOAD_DATE': '20220807',
  'QRZCOM_QSO_UPLOAD_STATUS': 'Y',
  'QSL_RCVD': 'N',
  'QSL_SENT': 'N',
  'QSL_VIA': 'QSL VIA DIRECT(3\$ SASE NOT IRC)',
  'QSO_DATE': '20220807',
  'QSO_DATE_OFF': '20220808',
  'QTH': 'CEUTA',
  'RST_RCVD': '-10',
  'RST_SENT': '-13',
  'STATION_CALLSIGN': 'S52KJ',
  'TIME_ON': '1952',
  'TIME_OFF': '1858',
  'TX_PWR': '20',
  'COMMENT': 'This is a comment',
};
