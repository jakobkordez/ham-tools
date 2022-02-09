part of 'log_entry.dart';

enum Band {
  lf2200m,
  mf160m,
  hf80m,
  hf40m,
  hf30m,
  hf20m,
  hf17m,
  hf15m,
  hf12m,
  hf10m,
  vhf6m,
  vhf4m,
  vhf2m,
  uhf70cm,
  uhf24cm,
  uhf13cm,
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
      case Band.mf160m:
        return 1800000;
      case Band.hf80m:
        return 3500000;
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
      case Band.uhf70cm:
        return 430000000;
      case Band.uhf24cm:
        return 1240000000;
      case Band.uhf13cm:
        return 2300000000;
    }
  }

  int get upperBound {
    switch (this) {
      case Band.lf2200m:
        return 137800;
      case Band.mf160m:
        return 2000000;
      case Band.hf80m:
        return 3800000;
      case Band.hf40m:
        return 7200000;
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
        return 52000000;
      case Band.vhf4m:
        return 70450000;
      case Band.vhf2m:
        return 146000000;
      case Band.uhf70cm:
        return 440000000;
      case Band.uhf24cm:
        return 1300000000;
      case Band.uhf13cm:
        return 2450000000;
    }
  }

  String get label {
    switch (this) {
      case Band.lf2200m:
        return '2200 m';
      case Band.mf160m:
        return '160 m';
      case Band.hf80m:
        return '80 m';
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
      case Band.uhf70cm:
        return '70 cm';
      case Band.uhf24cm:
        return '24 cm';
      case Band.uhf13cm:
        return '13 cm';
    }
  }

  String get name {
    switch (this) {
      case Band.lf2200m:
        return '2200m';
      case Band.mf160m:
        return '160m';
      case Band.hf80m:
        return '80m';
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
      case Band.uhf70cm:
        return '70cm';
      case Band.uhf24cm:
        return '24cm';
      case Band.uhf13cm:
        return '13cm';
    }
  }
}
