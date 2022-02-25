import 'package:flutter_test/flutter_test.dart';
import 'package:ping_app/provider/ping_provider.dart';

void main() {
  test(
    "Ping Google",
    () {
      int count = 5;
      PingProvider provider = PingProvider();
      provider.startPing(count: 5);

      expect(provider.pings.length, count + 1);
    },
  );
}
