import 'package:audioplayers/audioplayers.dart';
import 'package:hot_cold/locator.dart';

class SoundsPlayer {
  final soundsPlayer = AudioPlayer();
  static const double volumeMultiplier = 0.5;

  void playJumpSound() {
    soundsPlayer.play(
      AssetSource('audio/jump_sound.wav'),
      volume: settings().soundsVolume * volumeMultiplier,
    );
  }

  void playContactSound() {
    soundsPlayer.play(
      AssetSource('audio/landing_sound.wav'),
      volume: (settings().soundsVolume / 5) * volumeMultiplier,
    );
  }
}
