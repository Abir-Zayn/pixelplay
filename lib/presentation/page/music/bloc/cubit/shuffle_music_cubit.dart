import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

part 'shuffle_music_state.dart';

class ShuffleMusicCubit extends Cubit<ShuffleMusicState> {
  final SongsFirebaseService _songsService;
  final AudioPlayerService _audioService;

  ShuffleMusicCubit(this._songsService, this._audioService)
      : super(ShuffleMusicInitial());

  Future<void> shufflePlaylist() async {
    emit(ShuffleMusicLoading());
    try {
      final result = await _songsService.getPlayList();
      result.fold(
        (error) => emit(ShuffleMusicError(error.toString())),
        (songs) {
          // Initialize the playlist if needed
          if (_audioService.currentPlaylist.isEmpty) {
            _audioService.initializePlaylist(songs);
          }
          // Shuffle the playlist
          _audioService.shufflePlaylistMusic();
          // If nothing is currently playing, start playing the first song
          if (!_audioService.isPlayingState && songs.isNotEmpty) {
            _audioService.playNext();
          }
        },
      );
    } catch (e) {
      emit(ShuffleMusicError('Failed to shuffle: ${e.toString()}'));
    }
  }
}

