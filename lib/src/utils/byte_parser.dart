import 'dart:typed_data';

import '../models/time.dart';

class ByteParser {
  static const _qDataStreamNull = 0xffffffff;

  int _offset = 0;
  final ByteData data;

  ByteParser(this.data);

  bool parseBool() => parseUint8() != 0;

  int parseUint8() {
    _offset += 1;
    return data.getUint8(_offset - 1);
  }

  int parseUint32() {
    _offset += 4;
    return data.getUint32(_offset - 4);
  }

  int parseInt32() {
    _offset += 4;
    return data.getInt32(_offset - 4);
  }

  int parseUint64() {
    _offset += 8;
    return data.getUint64(_offset - 8);
  }

  double parseDouble() {
    _offset += 8;
    return data.getFloat64(_offset - 8);
  }

  String parseUtf8() {
    final len = parseUint32();
    if (len == _qDataStreamNull) return '';
    _offset += len;
    return String.fromCharCodes(data.buffer.asInt8List(_offset - len, len));
  }

  Time parseQTime() {
    return Time.fromMilliseconds(parseUint32());
  }

  DateTime parseQDateTime() {
    final julDay = parseUint64();
    int msMid = parseUint32();
    final h = msMid ~/ 3600000;
    msMid %= 3600000;
    final m = msMid ~/ 60000;
    msMid %= 60000;
    final s = msMid ~/ 1000;

    final isUtc = parseBool();
    if (!isUtc) {
      return DateTime(-4713, 11, 24 + julDay, h, m, s);
    }

    return DateTime.utc(-4713, 11, 24 + julDay, h, m, s);
  }
}
