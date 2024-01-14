import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SettingsStore extends Cubit<Settings> {
  late final Box box;

  SettingsStore() : super(Settings.initial) {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('settings');
    _loadStateFromBox();
  }

  void _loadStateFromBox() => emit(
        Settings(
          rayDensity: rayDensity,
          musicVolume: musicVolume,
          soundsVolume: soundsVolume,
        ),
      );

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

  double get soundsVolume => box.get('sounds_volume', defaultValue: 0.5);
  void setSoundsVolume(double volume) {
    if (volume == state.soundsVolume) return;
    box.put('sounds_volume', volume);
    emit(state.copyWith(soundsVolume: volume));
  }
}

class Settings {
  final double rayDensity;
  final double musicVolume;
  final double soundsVolume;

  const Settings({
    required this.rayDensity,
    required this.musicVolume,
    required this.soundsVolume,
  });

  static const initial = Settings(
    rayDensity: 16,
    musicVolume: 0.5,
    soundsVolume: 0.5,
  );

  Settings copyWith({
    double? rayDensity,
    double? musicVolume,
    double? soundsVolume,
  }) =>
      Settings(
        rayDensity: rayDensity ?? this.rayDensity,
        musicVolume: musicVolume ?? this.musicVolume,
        soundsVolume: soundsVolume ?? this.soundsVolume,
      );
}
