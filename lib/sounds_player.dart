import 'package:audioplayers/audioplayers.dart';

class SoundsPlayer {
  final soundsPlayer = AudioPlayer();

  void playSound(AssetSource soundName, double volume) {
    soundsPlayer.play(soundName, volume: volume);
  }
}
