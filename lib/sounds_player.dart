import 'package:audioplayers/audioplayers.dart';
import 'package:hot_cold/locator.dart';

class SoundsPlayer {
  final soundsPlayer = AudioPlayer();

  void playJumpSound() async {
    await soundsPlayer.play(
      AssetSource('audio/jump_sound.wav'),
      volume: settings().soundsVolume * 0.5,
    );
  }

  void playContactSound() async {
    await soundsPlayer.play(
      AssetSource('audio/landing_sound.wav'),
      volume: settings().soundsVolume * 0.1,
    );
  }
}
