import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:udp/udp.dart';

import '../../utils/adif.dart';
import '../log_entry.dart';
import '../wsjt_message.dart';
import 'qso_stream.dart';

class WsjtQsoStream extends QsoStream {
  final String? ip;
  final int port;
  final UDP _udp;

  @override
  final Stream<LogEntry> stream;

  WsjtQsoStream._(this.ip, this.port, this._udp, this.stream);

  static Future<WsjtQsoStream> connect([int port = 2237, String? ip]) async {
    final udp = await UDP.bind(ip != null
        ? Endpoint.unicast(InternetAddress.tryParse('$ip:$port'))
        : Endpoint.loopback(port: Port(port)));

    final stream = udp.asStream().transform<LogEntry>(
      StreamTransformer<Datagram, LogEntry>.fromHandlers(
        handleData: (data, sink) {
          try {
            final d = WsjtMessage.parseMessage(data.data);
            if (d is! LoggedAdifMessage) return;
            sink.add(LogEntry.fromAdiMap(Adif.decodeAdi(d.adif).first));
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );

    return WsjtQsoStream._(ip, port, udp, stream.asBroadcastStream());
  }

  @override
  void dispose() {
    _udp.close();
  }
}
