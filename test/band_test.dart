import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/log_entry.dart';

void main() {
  test('Band range', () {
    for (final band in Band.values) {
      expect(band.upperBound, greaterThan(band.lowerBound));
    }
  });

  test('Band overlap', () {
    for (int i = 1; i < Band.values.length; i++) {
      expect(Band.values[i].lowerBound,
          greaterThan(Band.values[i - 1].upperBound));
    }
  });
}
