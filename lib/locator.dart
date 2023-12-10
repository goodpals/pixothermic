import 'package:get_it/get_it.dart';
import 'package:hot_cold/store/level_store.dart';
import 'package:hot_cold/store/progress_store.dart';
import 'package:hot_cold/store/settings_store.dart';

final GetIt locator = GetIt.instance;

ProgressStore progress() => locator<ProgressStore>();
LevelStore levelStore() => locator<LevelStore>();
SettingsStore settings() => locator<SettingsStore>();

Future<void> setupLocator() async {
  locator.registerSingleton<ProgressStore>(ProgressStore());
  locator.registerSingleton<LevelStore>(LevelStore());
  locator.registerSingleton<SettingsStore>(SettingsStore());
}
