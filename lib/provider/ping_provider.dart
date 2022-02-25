import 'dart:async';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/cupertino.dart';

class PingProvider with ChangeNotifier {
  Ping? ping;
  List<PingData> pings = [];
  PingSummary? summary;
  late int sum;

  StreamSubscription? stream;

  listener(PingData event) {
    if (event.response != null) {
      sum += event.response!.time?.inMilliseconds ?? 0;
    }
    pings.add(event);
    notifyListeners();
  }

  PingProvider() {
    sum = 0;
  }

  void startPing({int count = 5}) async {
    pings.clear();
    summary = null;
    sum = 0;
    notifyListeners();

    if (stream != null) {
      await stream!.cancel();
    }

    if (ping != null) {
      await ping!.stop();
    }

    ping = Ping("google.com", count: count);
    stream = ping!.stream.listen(listener);
  }
}
