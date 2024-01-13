import 'package:audioplayers/audioplayers.dart';

class SoundsPlayer {
  final soundsPlayer = AudioPlayer();

  void playJumpSound() {
    soundsPlayer.play(AssetSource('audio/jump_sound.wav'), volume: 0.3);
  }

  void playContactSound() {
    soundsPlayer.play(AssetSource('audio/landing_sound.wav'), volume: 0.05);
  }
}
