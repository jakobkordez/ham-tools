import 'package:collection/collection.dart';

class QslRcvd {
  /// - an incoming QSL card has been received
  /// - the QSO has been confirmed by the online service
  static const yes = QslRcvd._('Y', 'Yes');

  /// - an incoming QSL card has not been received
  /// - the QSO has not been confirmed by the online service
  static const no = QslRcvd._('N', 'No');

  /// - the logging station has requested a QSL card
  /// - the logging station has requested the QSO be uploaded to the online service
  static const requested = QslRcvd._('R', 'Requested');

  static const ignore = QslRcvd._('I', 'Ignore');

  /// Import only
  static const verified = QslRcvd._('V', 'Verified');

  static const values = [yes, no, requested, ignore, verified];

  final String name;
  final String label;

  const QslRcvd._(this.name, this.label);

  static QslRcvd? fromName(String? name) {
    if (name == null) return null;
    name = name.toUpperCase();
    return values.firstWhereOrNull((e) => e.name == name);
  }
}

class QslSent {
  /// - an outgoing QSL card has been sent
  /// - the QSO has been uploaded to, and accepted by, the online service
  static const yes = QslSent._('Y', 'Yes');

  /// - do not send an outgoing QSL card
  /// - do not upload the QSO to the online service
  static const no = QslSent._('N', 'No');

  /// - the contacted station has requested a QSL card
  /// - the contacted station has requested the QSO be uploaded to the online service
  static const requested = QslSent._('R', 'Requested');

  /// - an outgoing QSL card has been selected to be sent
  /// - a QSO has been selected to be uploaded to the online service
  static const queued = QslSent._('Q', 'Queued');

  static const ignore = QslSent._('I', 'Ignore');

  static const values = [yes, no, requested, queued, ignore];

  final String name;
  final String label;

  const QslSent._(this.name, this.label);

  static QslSent? fromName(String? name) {
    if (name == null) return null;
    name = name.toUpperCase();
    return values.firstWhereOrNull((e) => e.name == name);
  }
}
