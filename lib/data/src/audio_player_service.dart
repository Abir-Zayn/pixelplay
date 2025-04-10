import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

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

  // Add a stream controller for the current song ID
  final _currentSongController = StreamController<String>.broadcast();
  Stream<String> get currentSongStream => _currentSongController.stream;

  // Getter for the current play state
  bool get isPlayingState => isPlaying;

  // Track the current Song ID
  String _currentSongId = "";
  String get currentSongId => currentSongId;
  bool isShuffleMode = false;

  List<SongEntity> currentPlaylist = [];
  List<SongEntity> shufflePlaylist = [];
  int currentIndex = -1;

  // Constructor with player state listener
  AudioPlayerService() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  //toggle the shuffle mode
  void toggleShuffleMode() {
    isShuffleMode = !isShuffleMode;
    if (isShuffleMode) shufflePlaylistMusic();
  }

  //Initialize PlayList
  Future<void> initializePlaylist(List<SongEntity> playlist) async {
    currentPlaylist = playlist;
    shufflePlaylistMusic();
    currentIndex = -1;
  }

  // Method to shuffle the playlist
  // It uses the shuffle method to randomize the order of the songs in the playlist
  void shufflePlaylistMusic() {
    shufflePlaylist = List.from(currentPlaylist);
    shufflePlaylist.shuffle();
  }

  // New Method to play next song in shuffle playlist
  Future<void> playNext() async {
    if (currentPlaylist.isEmpty) return;

    if (isShuffleMode) {
      if (shufflePlaylist.isEmpty) {
        shufflePlaylistMusic();
      }
      currentIndex = (currentIndex + 1) % shufflePlaylist.length;
      final nextSong = shufflePlaylist[currentIndex];
      _currentSongId = nextSong.id;
      _currentSongController.add(_currentSongId); // Notify listeners
      await play(nextSong.musicUrl);
    } else {
      if (currentPlaylist.isEmpty) return;
      currentIndex = (currentIndex + 1) % currentPlaylist.length;
      final nextSong = currentPlaylist[currentIndex];
      _currentSongId = nextSong.id; // Update current song ID
      _currentSongController.add(_currentSongId); // Notify listeners
      await play(nextSong.musicUrl);
    }
  }

  // Play a specific song by ID
  Future<void> playById(String songId) async {
    // Find song in playlist
    int index = currentPlaylist.indexWhere((song) => song.id == songId);
    if (index != -1) {
      currentIndex = index;
      _currentSongId = songId;
      _currentSongController.add(_currentSongId);
      await play(currentPlaylist[index].musicUrl);
    }
  }

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
    await _currentSongController.close();
    await _stateController.close();
    await _audioPlayer.dispose();
  }
}
