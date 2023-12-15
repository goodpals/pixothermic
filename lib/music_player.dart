import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final player = AudioPlayer();

  void playMusicLoop() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('music.mp3'), volume: 0.1);
  }

  void stopMusic() async {
    await player.stop();
  }

  void toggleMusic() async {
    if (player.state == PlayerState.stopped) {
      playMusicLoop();
    } else {
      stopMusic();
    }
  }
}
