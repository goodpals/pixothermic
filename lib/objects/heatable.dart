import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/utils/long_tick.dart';

mixin Heatable on LongTick {
  double temperature = 0;
  int tempLock = 0;
  int get tempHoldTicks => 10;
  double get heatDissipationRate => 1.0;
  (double, double) get tempRange => (-1, 1);

  @override
  void onLongTick() {
    if (tempLock == 0) {
      if (temperature != 0) {
        temperature +=
            temperature > 0 ? -temperatureSubdivision : temperatureSubdivision;
        if (temperature.abs() < temperatureSubdivision) temperature = 0;
        onTemperatureChange();
      }
    } else {
      tempLock--;
    }
    print((tempLock, temperature));
  }

  void heat(double amount) {
    temperature = (temperature + amount).clamp(tempRange.$1, tempRange.$2);
    tempLock = tempHoldTicks;
    onTemperatureChange();
  }

  void onTemperatureChange();
}
