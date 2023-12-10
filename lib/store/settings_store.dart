import 'package:hive/hive.dart';

class SettingsStore {
  late final Box box;

  SettingsStore() {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('settings');
  }

  double get rayDensity => box.get('rayDensity', defaultValue: 64.0);
  void setRayDensity(double density) => box.put('rayDensity', density);
}
