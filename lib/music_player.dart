import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final player = AudioPlayer();

  void playMusicLoop() async {
    player.setReleaseMode(ReleaseMode.loop);
    player.play(AssetSource('music.mp3'), volume: 0.1);
  }

  void stopMusic() async {
    player.stop();
  }

  void toggleMusic() async {
    if (player.state == PlayerState.playing) {
      stopMusic();
    } else {
      playMusicLoop();
    }
  }
}
