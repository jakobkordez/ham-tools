part of 'log_entry.dart';

enum Mode {
  /// AM
  am,

  /// ARDOP
  ardop,

  /// ATV
  atv,

  /// C4FM
  c4fm,

  /// CHIP
  chip,

  /// CLO
  clo,

  /// CONTESTI
  contesti,

  /// CW
  cw,

  /// DIGITALVOICE
  digitalvoice,

  /// DOMINO
  domino,

  /// DSTAR
  dstar,

  /// FAX
  fax,

  /// FM
  fm,

  /// FSK441
  fsk441,

  /// FT8
  ft8,

  /// HELL
  hell,

  /// ISCAT
  iscat,

  /// JT4
  jt4,

  /// JT6M
  jt6m,

  /// JT9
  jt9,

  /// JT44
  jt44,

  /// JT65
  jt65,

  /// MFSK
  mfsk,

  /// MSK144
  msk144,

  /// MT63
  mt63,

  /// OLIVIA
  olivia,

  /// OPERA
  opera,

  /// PAC
  pac,

  /// PAX
  pax,

  /// PKT
  pkt,

  /// PSK
  psk,

  /// PSK2K
  psk2k,

  /// Q15
  q15,

  /// QRA64
  qra64,

  /// ROS
  ros,

  /// RTTY
  rtty,

  /// RTTYM
  rttym,

  /// SSB
  ssb,

  /// SSTV
  sstv,

  /// T10
  t10,

  /// THOR
  thor,

  /// THRB
  thrb,

  /// TOR
  tor,

  /// V4
  v4,

  /// VOI
  voi,

  /// WINMOR
  winmor,

  /// WSPR
  wspr
}

extension ModeUtil on Mode {
  static Mode? tryParse(String? value) {
    if (value == null) return null;
    value = value.toUpperCase();
    return Mode.values.firstWhereOrNull((m) => m.name == value);
  }

  static List<Mode> get topModes =>
      [Mode.cw, Mode.ssb, Mode.am, Mode.fm, Mode.rtty, Mode.ft8];

  String? get defaultReport {
    switch (this) {
      case Mode.cw:
      case Mode.rtty:
        return '599';
      case Mode.ssb:
      case Mode.am:
      case Mode.fm:
        return '59';
      default:
        return null;
    }
  }

  List<SubMode> get subModes {
    switch (this) {
      case Mode.chip:
        return [SubMode.chip64, SubMode.chip128];
      case Mode.cw:
        return [SubMode.pcw];
      case Mode.domino:
        return [SubMode.dominoex, SubMode.dominof];
      case Mode.hell:
        return [
          SubMode.fmhell,
          SubMode.fskhell,
          SubMode.hell80,
          SubMode.hfsk,
          SubMode.pskhell,
        ];
      case Mode.iscat:
        return [SubMode.iscatA, SubMode.iscatB];
      case Mode.jt4:
        return [
          SubMode.jt4a,
          SubMode.jt4b,
          SubMode.jt4c,
          SubMode.jt4d,
          SubMode.jt4e,
          SubMode.jt4f,
          SubMode.jt4g,
        ];
      case Mode.jt9:
        return [
          SubMode.jt9_1,
          SubMode.jt9_2,
          SubMode.jt9_5,
          SubMode.jt9_10,
          SubMode.jt9_30,
          SubMode.jt9a,
          SubMode.jt9b,
          SubMode.jt9c,
          SubMode.jt9d,
          SubMode.jt9e,
          SubMode.jt9eFast,
          SubMode.jt9f,
          SubMode.jt9fFast,
          SubMode.jt9g,
          SubMode.jt9gFast,
          SubMode.jt9h,
          SubMode.jt9hFast,
        ];
      case Mode.jt65:
        return [
          SubMode.jt65a,
          SubMode.jt65b,
          SubMode.jt65b2,
          SubMode.jt65c,
          SubMode.jt65c2,
        ];
      case Mode.mfsk:
        return [
          SubMode.fsqcall,
          SubMode.ft4,
          SubMode.js8,
          SubMode.mfsk4,
          SubMode.mfsk8,
          SubMode.mfsk11,
          SubMode.mfsk16,
          SubMode.mfsk22,
          SubMode.mfsk31,
          SubMode.mfsk32,
          SubMode.mfsk64,
          SubMode.mfsk128,
        ];
      case Mode.olivia:
        return [
          SubMode.olivia_4_125,
          SubMode.olivia_4_250,
          SubMode.olivia_8_250,
          SubMode.olivia_8_500,
          SubMode.olivia_16_500,
          SubMode.olivia_16_1000,
          SubMode.olivia_32_1000,
        ];
      case Mode.opera:
        return [SubMode.operaBeacon, SubMode.operaQso];
      case Mode.pac:
        return [SubMode.pac2, SubMode.pac3, SubMode.pac4];
      case Mode.pax:
        return [SubMode.pax2];
      case Mode.psk:
        return [
          SubMode.fsk31,
          SubMode.psk10,
          SubMode.psk31,
          SubMode.psk63,
          SubMode.psk63f,
          SubMode.psk125,
          SubMode.psk250,
          SubMode.psk500,
          SubMode.psk1000,
          SubMode.pskam10,
          SubMode.pskam31,
          SubMode.pskam50,
          SubMode.pskfec31,
          SubMode.qpsk31,
          SubMode.qpsk63,
          SubMode.qpsk125,
          SubMode.qpsk250,
          SubMode.qpsk500,
          SubMode.sim31,
        ];
      case Mode.qra64:
        return [
          SubMode.qra64a,
          SubMode.qra64b,
          SubMode.qra64c,
          SubMode.qra64d,
          SubMode.qra64e,
        ];
      case Mode.ros:
        return [SubMode.rosEme, SubMode.rosHf, SubMode.rosMf];
      case Mode.rtty:
        return [SubMode.asci];
      case Mode.ssb:
        return [SubMode.lsb, SubMode.usb];
      case Mode.thrb:
        return [SubMode.thrbx];
      case Mode.tor:
        return [SubMode.amtorfec, SubMode.gtor];
      default:
        return const [];
    }
  }

  String get name {
    switch (this) {
      case Mode.am:
        return 'AM';
      case Mode.ardop:
        return 'ARDOP';
      case Mode.atv:
        return 'ATV';
      case Mode.c4fm:
        return 'C4FM';
      case Mode.chip:
        return 'CHIP';
      case Mode.clo:
        return 'CLO';
      case Mode.contesti:
        return 'CONTESTI';
      case Mode.cw:
        return 'CW';
      case Mode.digitalvoice:
        return 'DIGITALVOICE';
      case Mode.domino:
        return 'DOMINO';
      case Mode.dstar:
        return 'DSTAR';
      case Mode.fax:
        return 'FAX';
      case Mode.fm:
        return 'FM';
      case Mode.fsk441:
        return 'FSK441';
      case Mode.ft8:
        return 'FT8';
      case Mode.hell:
        return 'HELL';
      case Mode.iscat:
        return 'ISCAT';
      case Mode.jt4:
        return 'JT4';
      case Mode.jt6m:
        return 'JT6M';
      case Mode.jt9:
        return 'JT9';
      case Mode.jt44:
        return 'JT44';
      case Mode.jt65:
        return 'JT65';
      case Mode.mfsk:
        return 'MFSK';
      case Mode.msk144:
        return 'MSK144';
      case Mode.mt63:
        return 'MT63';
      case Mode.olivia:
        return 'OLIVIA';
      case Mode.opera:
        return 'OPERA';
      case Mode.pac:
        return 'PAC';
      case Mode.pax:
        return 'PAX';
      case Mode.pkt:
        return 'PKT';
      case Mode.psk:
        return 'PSK';
      case Mode.psk2k:
        return 'PSK2K';
      case Mode.q15:
        return 'Q15';
      case Mode.qra64:
        return 'QRA64';
      case Mode.ros:
        return 'ROS';
      case Mode.rtty:
        return 'RTTY';
      case Mode.rttym:
        return 'RTTYM';
      case Mode.ssb:
        return 'SSB';
      case Mode.sstv:
        return 'SSTV';
      case Mode.t10:
        return 'T10';
      case Mode.thor:
        return 'THOR';
      case Mode.thrb:
        return 'THRB';
      case Mode.tor:
        return 'TOR';
      case Mode.v4:
        return 'V4';
      case Mode.voi:
        return 'VOI';
      case Mode.winmor:
        return 'WINMOR';
      case Mode.wspr:
        return 'WSPR';
    }
  }
}

enum SubMode {
  /// none
  none,

  /// AMTORFEC
  amtorfec,

  /// ASCI
  asci,

  /// CHIP64
  chip64,

  /// CHIP128
  chip128,

  /// DOMINOEX
  dominoex,

  /// DOMINOF
  dominof,

  /// FMHELL
  fmhell,

  /// FSK31
  fsk31,

  /// FSKHELL
  fskhell,

  /// FSQCALL
  fsqcall,

  /// FT4
  ft4,

  /// GTOR
  gtor,

  /// HELL80
  hell80,

  /// HFSK
  hfsk,

  /// ISCAT-A
  iscatA,

  /// ISCAT-B
  iscatB,

  /// JS8
  js8,

  /// JT4A
  jt4a,

  /// JT4B
  jt4b,

  /// JT4C
  jt4c,

  /// JT4D
  jt4d,

  /// JT4E
  jt4e,

  /// JT4F
  jt4f,

  /// JT4G
  jt4g,

  /// JT9-1
  jt9_1,

  /// JT9-2
  jt9_2,

  /// JT9-5
  jt9_5,

  /// JT9-10
  jt9_10,

  /// JT9-30
  jt9_30,

  /// JT9A
  jt9a,

  /// JT9B
  jt9b,

  /// JT9C
  jt9c,

  /// JT9D
  jt9d,

  /// JT9E
  jt9e,

  /// JT9E FAST
  jt9eFast,

  /// JT9F
  jt9f,

  /// JT9F FAST
  jt9fFast,

  /// JT9G
  jt9g,

  /// JT9G FAST
  jt9gFast,

  /// JT9H
  jt9h,

  /// JT9H FAST
  jt9hFast,

  /// JT65A
  jt65a,

  /// JT65B
  jt65b,

  /// JT65B2
  jt65b2,

  /// JT65C
  jt65c,

  /// JT65C2
  jt65c2,

  /// LSB
  lsb,

  /// MFSK4
  mfsk4,

  /// MFSK8
  mfsk8,

  /// MFSK11
  mfsk11,

  /// MFSK16
  mfsk16,

  /// MFSK22
  mfsk22,

  /// MFSK31
  mfsk31,

  /// MFSK32
  mfsk32,

  /// MFSK64
  mfsk64,

  /// MFSK128
  mfsk128,

  /// OLIVIA 4/125
  olivia_4_125,

  /// OLIVIA 4/250
  olivia_4_250,

  /// OLIVIA 8/250
  olivia_8_250,

  /// OLIVIA 8/500
  olivia_8_500,

  /// OLIVIA 16/500
  olivia_16_500,

  /// OLIVIA 16/1000
  olivia_16_1000,

  /// OLIVIA 32/1000
  olivia_32_1000,

  /// OPERA-BEACON
  operaBeacon,

  /// OPERA-QSO
  operaQso,

  /// PAC2
  pac2,

  /// PAC3
  pac3,

  /// PAC4
  pac4,

  /// PAX2
  pax2,

  /// PCW
  pcw,

  /// PSK10
  psk10,

  /// PSK31
  psk31,

  /// PSK63
  psk63,

  /// PSK63F
  psk63f,

  /// PSK125
  psk125,

  /// PSK250
  psk250,

  /// PSK500
  psk500,

  /// PSK1000
  psk1000,

  /// PSKAM10
  pskam10,

  /// PSKAM31
  pskam31,

  /// PSKAM50
  pskam50,

  /// PSKFEC31
  pskfec31,

  /// PSKHELL
  pskhell,

  /// QPSK31
  qpsk31,

  /// QPSK63
  qpsk63,

  /// QPSK125
  qpsk125,

  /// QPSK250
  qpsk250,

  /// QPSK500
  qpsk500,

  /// QRA64A
  qra64a,

  /// QRA64B
  qra64b,

  /// QRA64C
  qra64c,

  /// QRA64D
  qra64d,

  /// QRA64E
  qra64e,

  /// ROS-EME
  rosEme,

  /// ROS-HF
  rosHf,

  /// ROS-MF
  rosMf,

  /// SIM31
  sim31,

  /// THRBX
  thrbx,

  /// USB
  usb
}

extension SubModeUtil on SubMode {
  static SubMode? tryParse(String? value) {
    if (value == null) return null;
    value = value.toUpperCase();
    return SubMode.values.firstWhereOrNull((m) => m.name == value);
  }

  String get name {
    switch (this) {
      case SubMode.none:
        return '__NONE__';
      case SubMode.amtorfec:
        return 'AMTORFEC';
      case SubMode.asci:
        return 'ASCI';
      case SubMode.chip64:
        return 'CHIP64';
      case SubMode.chip128:
        return 'CHIP128';
      case SubMode.dominoex:
        return 'DOMINOEX';
      case SubMode.dominof:
        return 'DOMINOF';
      case SubMode.fmhell:
        return 'FMHELL';
      case SubMode.fsk31:
        return 'FSK31';
      case SubMode.fskhell:
        return 'FSKHELL';
      case SubMode.fsqcall:
        return 'FSQCALL';
      case SubMode.ft4:
        return 'FT4';
      case SubMode.gtor:
        return 'GTOR';
      case SubMode.hell80:
        return 'HELL80';
      case SubMode.hfsk:
        return 'HFSK';
      case SubMode.iscatA:
        return 'ISCAT-A';
      case SubMode.iscatB:
        return 'ISCAT-B';
      case SubMode.js8:
        return 'JS8';
      case SubMode.jt4a:
        return 'JT4A';
      case SubMode.jt4b:
        return 'JT4B';
      case SubMode.jt4c:
        return 'JT4C';
      case SubMode.jt4d:
        return 'JT4D';
      case SubMode.jt4e:
        return 'JT4E';
      case SubMode.jt4f:
        return 'JT4F';
      case SubMode.jt4g:
        return 'JT4G';
      case SubMode.jt9_1:
        return 'JT9-1';
      case SubMode.jt9_2:
        return 'JT9-2';
      case SubMode.jt9_5:
        return 'JT9-5';
      case SubMode.jt9_10:
        return 'JT9-10';
      case SubMode.jt9_30:
        return 'JT9-30';
      case SubMode.jt9a:
        return 'JT9A';
      case SubMode.jt9b:
        return 'JT9B';
      case SubMode.jt9c:
        return 'JT9C';
      case SubMode.jt9d:
        return 'JT9D';
      case SubMode.jt9e:
        return 'JT9E';
      case SubMode.jt9f:
        return 'JT9F';
      case SubMode.jt9g:
        return 'JT9G';
      case SubMode.jt9h:
        return 'JT9H';
      case SubMode.jt9eFast:
        return 'JT9E FAST';
      case SubMode.jt9fFast:
        return 'JT9F FAST';
      case SubMode.jt9gFast:
        return 'JT9G FAST';
      case SubMode.jt9hFast:
        return 'JT9H FAST';
      case SubMode.jt65a:
        return 'JT65A';
      case SubMode.jt65b:
        return 'JT65B';
      case SubMode.jt65b2:
        return 'JT65B2';
      case SubMode.jt65c:
        return 'JT65C';
      case SubMode.jt65c2:
        return 'JT65C2';
      case SubMode.lsb:
        return 'LSB';
      case SubMode.mfsk4:
        return 'MFSK4';
      case SubMode.mfsk8:
        return 'MFSK8';
      case SubMode.mfsk11:
        return 'MFSK11';
      case SubMode.mfsk16:
        return 'MFSK16';
      case SubMode.mfsk22:
        return 'MFSK22';
      case SubMode.mfsk31:
        return 'MFSK31';
      case SubMode.mfsk32:
        return 'MFSK32';
      case SubMode.mfsk64:
        return 'MFSK64';
      case SubMode.mfsk128:
        return 'MFSK128';
      case SubMode.olivia_4_125:
        return 'OLIVIA 4/125';
      case SubMode.olivia_4_250:
        return 'OLIVIA 4/250';
      case SubMode.olivia_8_250:
        return 'OLIVIA 8/250';
      case SubMode.olivia_8_500:
        return 'OLIVIA 8/500';
      case SubMode.olivia_16_500:
        return 'OLIVIA 16/500';
      case SubMode.olivia_16_1000:
        return 'OLIVIA 16/1000';
      case SubMode.olivia_32_1000:
        return 'OLIVIA 32/1000';
      case SubMode.operaBeacon:
        return 'OPERA-BEACON';
      case SubMode.operaQso:
        return 'OPERA-QSO';
      case SubMode.pac2:
        return 'PAC2';
      case SubMode.pac3:
        return 'PAC3';
      case SubMode.pac4:
        return 'PAC4';
      case SubMode.pax2:
        return 'PAX2';
      case SubMode.pcw:
        return 'PCW';
      case SubMode.psk10:
        return 'PSK10';
      case SubMode.psk31:
        return 'PSK31';
      case SubMode.psk63:
        return 'PSK63';
      case SubMode.psk63f:
        return 'PSK63F';
      case SubMode.psk125:
        return 'PSK125';
      case SubMode.psk250:
        return 'PSK250';
      case SubMode.psk500:
        return 'PSK500';
      case SubMode.psk1000:
        return 'PSK1000';
      case SubMode.pskam10:
        return 'PSKAM10';
      case SubMode.pskam31:
        return 'PSKAM31';
      case SubMode.pskam50:
        return 'PSKAM50';
      case SubMode.pskfec31:
        return 'PSKFEC31';
      case SubMode.pskhell:
        return 'PSKHELL';
      case SubMode.qpsk31:
        return 'QPSK31';
      case SubMode.qpsk63:
        return 'QPSK63';
      case SubMode.qpsk125:
        return 'QPSK125';
      case SubMode.qpsk250:
        return 'QPSK250';
      case SubMode.qpsk500:
        return 'QPSK500';
      case SubMode.qra64a:
        return 'QRA64A';
      case SubMode.qra64b:
        return 'QRA64B';
      case SubMode.qra64c:
        return 'QRA64C';
      case SubMode.qra64d:
        return 'QRA64D';
      case SubMode.qra64e:
        return 'QRA64E';
      case SubMode.rosEme:
        return 'ROS-EME';
      case SubMode.rosHf:
        return 'ROS-HF';
      case SubMode.rosMf:
        return 'ROS-MF';
      case SubMode.sim31:
        return 'SIM31';
      case SubMode.thrbx:
        return 'THRBX';
      case SubMode.usb:
        return 'USB';
    }
  }
}
