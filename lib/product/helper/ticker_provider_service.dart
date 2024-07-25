import 'package:flutter/scheduler.dart';

class TickerProviderService implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

final TickerProviderService tickerProviderService = TickerProviderService();
