import 'package:collection/collection.dart';

enum Continent {
  africa,
  asia,
  europe,
  northAmerica,
  oceania,
  southAmerica,
  antarctica,
}

extension ContinentUtil on Continent {
  static Continent? tryParse(String? value) {
    if (value == null) return null;
    value = value.toUpperCase();
    return Continent.values.firstWhereOrNull((b) => b.name == value);
  }

  String get label {
    switch (this) {
      case Continent.africa:
        return 'Africa';
      case Continent.asia:
        return 'Asia';
      case Continent.europe:
        return 'Europe';
      case Continent.northAmerica:
        return 'North America';
      case Continent.oceania:
        return 'Oceania';
      case Continent.southAmerica:
        return 'South America';
      case Continent.antarctica:
        return 'Antarctica';
    }
  }

  String get name {
    switch (this) {
      case Continent.africa:
        return 'AF';
      case Continent.asia:
        return 'AS';
      case Continent.europe:
        return 'EU';
      case Continent.northAmerica:
        return 'NA';
      case Continent.oceania:
        return 'OC';
      case Continent.southAmerica:
        return 'SA';
      case Continent.antarctica:
        return 'AN';
    }
  }
}
