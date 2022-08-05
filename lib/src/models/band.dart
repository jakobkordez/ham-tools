part of 'log_entry.dart';

enum Band {
  /// 2200m band (136 kHz)
  lf2200m,

  /// 630m band (472 kHz)
  mf630m,

  /// 560m band (501 kHz)
  mf560m,

  /// 160m band (1.800 MHz)
  mf160m,

  /// 80m band (3.500 MHz)
  hf80m,

  /// 60m band (5.250 MHz)
  hf60m,

  /// 40m band (7.000 MHz)
  hf40m,

  /// 30m band (10.000 MHz)
  hf30m,

  /// 20m band (14.000 MHz)
  hf20m,

  /// 17m band (18.100 MHz)
  hf17m,

  /// 15m band (21.000 MHz)
  hf15m,

  /// 12m band (24.900 MHz)
  hf12m,

  /// 10m band (28.000 MHz)
  hf10m,

  /// 6m band (50 MHz)
  vhf6m,

  /// 4m band (70 MHz)
  vhf4m,

  /// 2m band (144 MHz)
  vhf2m,

  /// 1.25m band (222 MHz)
  vhf1_25m,

  /// 70cm band (440 MHz)
  uhf70cm,

  /// 33cm band (902 MHz)
  uhf33cm,

  /// 23cm band (1.2 GHz)
  uhf23cm,

  /// 13cm band (2.3 GHz)
  uhf13cm,

  /// 9cm band (3.4 GHz)
  shf9cm,

  /// 6cm band (5.6 GHz)
  shf6cm,

  /// 3cm band (10 GHz)
  shf3cm,

  /// 1.25cm band (24 GHz)
  shf1_25cm,

  /// 6mm band (47 GHz)
  ehf6mm,

  /// 4mm band (75 GHz)
  ehf4mm,

  /// 2.5mm band (122 GHz)
  ehf2_5mm,

  /// 2mm band (134 GHz)
  ehf2mm,

  /// 1mm band (241 GHz)
  ehf1mm,
}

extension BandUtil on Band {
  static Band? tryParse(String? value) {
    if (value == null) return null;
    value = value.toLowerCase();
    return Band.values.firstWhereOrNull((b) => b.name == value);
  }

  static Band? getBand(int frequency) {
    for (final band in Band.values) {
      if (band.isInBounds(frequency)) return band;
    }

    return null;
  }

  bool isInBounds(int frequency) =>
      frequency >= lowerBound && frequency <= upperBound;

  int get lowerBound {
    switch (this) {
      case Band.lf2200m:
        return 135700;
      case Band.mf630m:
        return 472000;
      case Band.mf560m:
        return 501000;
      case Band.mf160m:
        return 1800000;
      case Band.hf80m:
        return 3500000;
      case Band.hf60m:
        return 5060000;
      case Band.hf40m:
        return 7000000;
      case Band.hf30m:
        return 10100000;
      case Band.hf20m:
        return 14000000;
      case Band.hf17m:
        return 18068000;
      case Band.hf15m:
        return 21000000;
      case Band.hf12m:
        return 24890000;
      case Band.hf10m:
        return 28000000;
      case Band.vhf6m:
        return 50000000;
      case Band.vhf4m:
        return 70000000;
      case Band.vhf2m:
        return 144000000;
      case Band.vhf1_25m:
        return 222000000;
      case Band.uhf70cm:
        return 420000000;
      case Band.uhf33cm:
        return 902000000;
      case Band.uhf23cm:
        return 1240000000;
      case Band.uhf13cm:
        return 2300000000;
      case Band.shf9cm:
        return 3300000000;
      case Band.shf6cm:
        return 5650000000;
      case Band.shf3cm:
        return 10000000000;
      case Band.shf1_25cm:
        return 24000000000;
      case Band.ehf6mm:
        return 47000000000;
      case Band.ehf4mm:
        return 75500000000;
      case Band.ehf2_5mm:
        return 119980000000;
      case Band.ehf2mm:
        return 142000000000;
      case Band.ehf1mm:
        return 241000000000;
    }
  }

  int get upperBound {
    switch (this) {
      case Band.lf2200m:
        return 137800;
      case Band.mf630m:
        return 479000;
      case Band.mf560m:
        return 504000;
      case Band.mf160m:
        return 2000000;
      case Band.hf80m:
        return 4000000;
      case Band.hf60m:
        return 5450000;
      case Band.hf40m:
        return 7300000;
      case Band.hf30m:
        return 10150000;
      case Band.hf20m:
        return 14350000;
      case Band.hf17m:
        return 18168000;
      case Band.hf15m:
        return 21450000;
      case Band.hf12m:
        return 24990000;
      case Band.hf10m:
        return 29700000;
      case Band.vhf6m:
        return 54000000;
      case Band.vhf4m:
        return 71000000;
      case Band.vhf2m:
        return 148000000;
      case Band.vhf1_25m:
        return 225000000;
      case Band.uhf70cm:
        return 450000000;
      case Band.uhf33cm:
        return 928000000;
      case Band.uhf23cm:
        return 1300000000;
      case Band.uhf13cm:
        return 2450000000;
      case Band.shf9cm:
        return 3500000000;
      case Band.shf6cm:
        return 5925000000;
      case Band.shf3cm:
        return 10500000000;
      case Band.shf1_25cm:
        return 24250000000;
      case Band.ehf6mm:
        return 47200000000;
      case Band.ehf4mm:
        return 81500000000;
      case Band.ehf2_5mm:
        return 123000000000;
      case Band.ehf2mm:
        return 149000000000;
      case Band.ehf1mm:
        return 250000000000;
    }
  }

  String get label {
    switch (this) {
      case Band.lf2200m:
        return '2200 m';
      case Band.mf630m:
        return '630 m';
      case Band.mf560m:
        return '560 m';
      case Band.mf160m:
        return '160 m';
      case Band.hf80m:
        return '80 m';
      case Band.hf60m:
        return '60 m';
      case Band.hf40m:
        return '40 m';
      case Band.hf30m:
        return '30 m';
      case Band.hf20m:
        return '20 m';
      case Band.hf17m:
        return '17 m';
      case Band.hf15m:
        return '15 m';
      case Band.hf12m:
        return '12 m';
      case Band.hf10m:
        return '10 m';
      case Band.vhf6m:
        return '6 m';
      case Band.vhf4m:
        return '4 m';
      case Band.vhf2m:
        return '2 m';
      case Band.vhf1_25m:
        return '1.25 m';
      case Band.uhf70cm:
        return '70 cm';
      case Band.uhf33cm:
        return '33 cm';
      case Band.uhf23cm:
        return '23 cm';
      case Band.uhf13cm:
        return '13 cm';
      case Band.shf9cm:
        return '9 cm';
      case Band.shf6cm:
        return '6 cm';
      case Band.shf3cm:
        return '3 cm';
      case Band.shf1_25cm:
        return '1.25 cm';
      case Band.ehf6mm:
        return '6 mm';
      case Band.ehf4mm:
        return '4 mm';
      case Band.ehf2_5mm:
        return '2.5 mm';
      case Band.ehf2mm:
        return '2 mm';
      case Band.ehf1mm:
        return '1 mm';
    }
  }

  String get name {
    switch (this) {
      case Band.lf2200m:
        return '2190m';
      case Band.mf630m:
        return '630m';
      case Band.mf560m:
        return '560m';
      case Band.mf160m:
        return '160m';
      case Band.hf80m:
        return '80m';
      case Band.hf60m:
        return '60m';
      case Band.hf40m:
        return '40m';
      case Band.hf30m:
        return '30m';
      case Band.hf20m:
        return '20m';
      case Band.hf17m:
        return '17m';
      case Band.hf15m:
        return '15m';
      case Band.hf12m:
        return '12m';
      case Band.hf10m:
        return '10m';
      case Band.vhf6m:
        return '6m';
      case Band.vhf4m:
        return '4m';
      case Band.vhf2m:
        return '2m';
      case Band.vhf1_25m:
        return '1.25m';
      case Band.uhf70cm:
        return '70cm';
      case Band.uhf33cm:
        return '33cm';
      case Band.uhf23cm:
        return '23cm';
      case Band.uhf13cm:
        return '13cm';
      case Band.shf9cm:
        return '9cm';
      case Band.shf6cm:
        return '6cm';
      case Band.shf3cm:
        return '3cm';
      case Band.shf1_25cm:
        return '1.25cm';
      case Band.ehf6mm:
        return '6mm';
      case Band.ehf4mm:
        return '4mm';
      case Band.ehf2_5mm:
        return '2.5mm';
      case Band.ehf2mm:
        return '2mm';
      case Band.ehf1mm:
        return '1mm';
    }
  }
}
