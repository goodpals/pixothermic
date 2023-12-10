import 'package:hot_cold/models/constants.dart';
import 'package:hot_cold/utils/long_tick.dart';

mixin Heatable on LongTick {
  double temperature = 0;
  int tempLock = 0;

  /// Number of ticks to hold the temperature for after heating.
  int get tempHoldTicks => 10;

  /// Rate at which heat is dissipated when temp isn't locked.
  double get heatDissipationRate => 1.0;

  /// Rate at which heat is absorbed *from the sun*.
  double get heatAbsorptionRate => 1.0;

  /// Min and max temperature.
  (double, double) get tempRange => (-1, 1);

  @override
  void onLongTick() {
    if (tempLock <= 0) {
      if (temperature != 0) {
        temperature += (temperature > 0
                ? -temperatureSubdivision
                : temperatureSubdivision) *
            heatDissipationRate;
        if (temperature.abs() < temperatureSubdivision) temperature = 0;
        onTemperatureChange();
      }
    } else {
      tempLock--;
    }
  }

  void heat(double amount, {bool lock = true}) {
    temperature = (temperature + amount).clamp(tempRange.$1, tempRange.$2);
    if (lock) tempLock = tempHoldTicks;
    onTemperatureChange();
  }

  void heatOther(Heatable other, double amount) {
    heat(-amount, lock: false);
    other.heat(amount);
  }

  void onTemperatureChange();
}
