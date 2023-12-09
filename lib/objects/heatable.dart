import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/utils/long_tick.dart';

mixin Heatable on LongTick {
  double temperature = 0;
  int tempLock = 0;

  @override
  void onLongTick() {
    if (tempLock == 0) {
      if (temperature != 0) {
        temperature +=
            temperature > 0 ? -temperatureSubdivision : temperatureSubdivision;
        onTemperatureChange();
      }
    } else {
      tempLock--;
    }
  }

  void heat(double amount) {
    temperature += amount;
    tempLock = 10;
    onTemperatureChange();
  }

  void onTemperatureChange();
}
