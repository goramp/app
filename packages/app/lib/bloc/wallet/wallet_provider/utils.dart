import 'dart:async';

import 'package:goramp/bloc/index.dart';

typedef PollCallback = Future<bool> Function();

void poll(PollCallback callback, int interval, int count) {
  if (count > 0) {
    Timer(Duration(milliseconds: interval), () async {
      final done = await callback();
      if (!done) poll(callback, interval, count - 1);
    });
  }
}

void pollUntilReady(WalletProvider provider, int pollInterval, int pollCount) {
  poll(() async {
    if (provider.ready) {
      provider.emit('ready');
    }
    return provider.ready;
  }, pollInterval, pollCount);
}
