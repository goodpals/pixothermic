import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SettingsStore extends Cubit<Settings> {
  late final Box box;

  SettingsStore() : super(Settings.initial) {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('settings');
  }

  double get rayDensity => box.get('ray_density', defaultValue: 16.0);
  void setRayDensity(double density) {
    if (density == state.rayDensity) return;
    box.put('ray_density', density);
    emit(state.copyWith(rayDensity: density));
  }

  double get musicVolume => box.get('music_volume', defaultValue: 0.5);
  void setMusicVolume(double volume) {
    if (volume == state.musicVolume) return;
    box.put('music_volume', volume);
    emit(state.copyWith(musicVolume: volume));
  }
}

class Settings {
  final double rayDensity;
  final double musicVolume;

  const Settings({
    required this.rayDensity,
    required this.musicVolume,
  });

  static const initial = Settings(
    rayDensity: 16,
    musicVolume: 0.5,
  );

  Settings copyWith({
    double? rayDensity,
    double? musicVolume,
  }) =>
      Settings(
        rayDensity: rayDensity ?? this.rayDensity,
        musicVolume: musicVolume ?? this.musicVolume,
      );
}
