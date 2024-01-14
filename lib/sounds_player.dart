import 'package:audioplayers/audioplayers.dart';
import 'package:hot_cold/locator.dart';

class SoundsPlayer {
  final soundsPlayer = AudioPlayer();

  void playJumpSound() {
    soundsPlayer.play(
      AssetSource('audio/jump_sound.wav'),
      volume: settings().soundsVolume * 0.5,
    );
  }

  void playContactSound() {
    soundsPlayer.play(
      AssetSource('audio/landing_sound.wav'),
      volume: settings().soundsVolume * 0.1,
    );
  }
}
