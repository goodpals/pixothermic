import 'package:hive/hive.dart';

class SettingsStore {
  late final Box box;

  SettingsStore() {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('settings');
  }

  double get rayDensity => box.get('ray_density', defaultValue: 16.0);
  void setRayDensity(double density) => box.put('ray_density', density);
}
