import 'dart:async';
import 'package:just_audio/just_audio.dart';

// AudioPlayerService class to manage audio playback
// This class uses the just_audio package to handle audio playback
// It provides methods to play, pause, stop, and seek audio tracks for now.

class AudioPlayerService {
  // Singleton instance of AudioPlayerService
  final AudioPlayer _audioPlayer = AudioPlayer();

  //getter function to access the audio player instance
  AudioPlayer get player => _audioPlayer;

  // Current URL of the audio track being played
  String? _currentUrl;
  // Flag to indicate if audio is currently playing
  bool isPlaying = false;

  // StreamController
  // A StreamController is a fundamental class in Dart that manages and controls a stream.
  // It serves as both the source of events in a stream and a way to add listeners to that stream.
  final _stateController = StreamController<bool>.broadcast();

  // Getter function to access the play state stream
  Stream<bool> get playStateStream => _stateController.stream;

  // Getter for the current play state
  bool get isPlayingState => isPlaying;

  // Method to play an audio track from a given URL
  // It checks if the URL is different from the current one before playing
  // if the URL is the same, it simply plays the audio
  // if the url is different, it sets the new URL and then plays it
  Future<void> play(String url) async {
    try {
      if (_currentUrl != url) {
        _currentUrl = url;
        await _audioPlayer.setUrl(url);
      }
      await _audioPlayer.play();
      isPlaying = true;
      _stateController.add(isPlaying);
    } catch (e) {
      isPlaying = false;
      _stateController.add(isPlaying);
      print("Error playing audio: $e");
    }
  }

  // Method to pause the audio playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      isPlaying = false;
      _stateController.add(isPlaying);
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  // Method to stop the audio playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      isPlaying = false;
      _stateController.add(isPlaying);
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  // Method to seek to a specific position in the audio track
  // It takes a Duration object as an argument and seeks to that position
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print("Error seeking audio: $e");
    }
  }

  // Properly disposes resources when the service is no longer needed
  Future<void> dispose() async {
    await _stateController.close();
    await _audioPlayer.dispose();
  }
}
