import 'package:audioplayers/audioplayers.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/store/settings_store.dart';

class MusicPlayer {
  static const _volumeMultiplier = 0.2;
  static const _musicFilePath = 'audio/music.mp3';
  final player = AudioPlayer();

  bool get isPlaying => player.state == PlayerState.playing;

  MusicPlayer() {
    settings().stream.listen(_onSettings);
  }

  double _volume(double volume) => (volume * _volumeMultiplier).clamp(0, 1);

  void _onSettings(Settings settings) {
    setVolume(settings.musicVolume);
  }

  void playMusicLoop() async {
    final vol = _volume(settings().musicVolume);
    if (vol <= 0) return;

    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource(_musicFilePath), volume: vol);
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

  void setVolume(double volume) {
    final vol = _volume(volume);
    if (vol <= 0 && isPlaying) {
      return stopMusic();
    }

    if (!isPlaying) {
      return playMusicLoop();
    }
    player.setVolume(vol);
  }
}
