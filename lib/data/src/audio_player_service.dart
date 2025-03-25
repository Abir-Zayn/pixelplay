import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Expose the player for stream access
  AudioPlayer get player => _audioPlayer;
  String? _currentUrl;

  Future<void> play(String url) async {
    try {
      // Only set the source if it's different from the current one
      if (_currentUrl != url) {
        _currentUrl = url;
        await _audioPlayer.setUrl(url);
      }

      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print("Error seeking audio: $e");
    }
  }

  // This method should be called in your app's dispose
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
