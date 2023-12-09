import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/utils/long_tick.dart';

mixin Heatable on LongTick {
  double temperature = 0;
  int tempLock = 0;
  int get tempHoldTicks => 10;
  double get heatDissipationRate => 1.0;

  @override
  void onLongTick() {
    if (tempLock == 0) {
      if (temperature != 0) {
        temperature += temperature > 0
            ? -temperatureSubdivision * heatDissipationRate
            : temperatureSubdivision * heatDissipationRate;
        onTemperatureChange();
      }
    } else {
      tempLock--;
    }
  }

  void heat(double amount) {
    temperature += amount;
    tempLock = tempHoldTicks;
    onTemperatureChange();
  }

  void onTemperatureChange();
}
