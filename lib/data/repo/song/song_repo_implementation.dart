import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class SongRepositoryImplementation extends SongRepo {
  @override
  Future<Either> getNewSong() async {
    return await sl<SongsFirebaseService>().getNewSong();
  }

  @override
  Future<Either> getPlayList() async {
    return await sl<SongsFirebaseService>().getPlayList();
  }

  @override
  Future<Either<String, SongEntity>> getSongById(String songId) async {
    return await sl<SongsFirebaseService>().getSongById(songId);
  }

  @override
  Future<Either> addOrRemoveFavSong(String songId) async {
    return await sl<SongsFirebaseService>().addOrRemoveFavSong(songId);
  }

  @override
  Future<bool> checkIfSongIsFav(String songId) {
    return sl<SongsFirebaseService>().checkIfSongIsFav(songId);
  }

  @override
  Future<Either> getUserFavSong() async {
    return await sl<SongsFirebaseService>().getUserFavSong();
  }
}
