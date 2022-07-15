enum CabrilloCategoryBand {
  /// All bands
  all,

  /// 160m band (1.800 MHz)
  mf160m,

  /// 80m band (3.500 MHz)
  hf80m,

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

  /// Light
  light,

  /// VHF 3 band (ARRL VHF Contests only)
  vhf3band,

  /// VHF FM only (ARRL VHF Contests only)
  vhffm
}

extension on CabrilloCategoryBand {
  String get name {
    switch (this) {
      case CabrilloCategoryBand.all:
        return 'ALL';
      case CabrilloCategoryBand.mf160m:
        return '160M';
      case CabrilloCategoryBand.hf80m:
        return '80M';
      case CabrilloCategoryBand.hf40m:
        return '40M';
      case CabrilloCategoryBand.hf30m:
        return '30M';
      case CabrilloCategoryBand.hf20m:
        return '20M';
      case CabrilloCategoryBand.hf17m:
        return '17M';
      case CabrilloCategoryBand.hf15m:
        return '15M';
      case CabrilloCategoryBand.hf12m:
        return '12M';
      case CabrilloCategoryBand.hf10m:
        return '10M';
      case CabrilloCategoryBand.vhf6m:
        return '6M';
      case CabrilloCategoryBand.vhf2m:
        return '2M';
      case CabrilloCategoryBand.vhf1_25m:
        return '222';
      case CabrilloCategoryBand.uhf70cm:
        return '432';
      case CabrilloCategoryBand.uhf33cm:
        return '902';
      case CabrilloCategoryBand.uhf23cm:
        return '1.2G';
      case CabrilloCategoryBand.uhf13cm:
        return '2.3G';
      case CabrilloCategoryBand.shf9cm:
        return '3.4G';
      case CabrilloCategoryBand.shf6cm:
        return '5.7G';
      case CabrilloCategoryBand.shf3cm:
        return '10G';
      case CabrilloCategoryBand.shf1_25cm:
        return '24G';
      case CabrilloCategoryBand.ehf6mm:
        return '47G';
      case CabrilloCategoryBand.ehf4mm:
        return '75G';
      case CabrilloCategoryBand.ehf2_5mm:
        return '122G';
      case CabrilloCategoryBand.ehf2mm:
        return '134G';
      case CabrilloCategoryBand.ehf1mm:
        return '241G';
      case CabrilloCategoryBand.light:
        return 'LIGHT';
      case CabrilloCategoryBand.vhf3band:
        return 'VHF-3-BAND';
      case CabrilloCategoryBand.vhffm:
        return 'VHF-FM-ONLY';
    }
  }
}
