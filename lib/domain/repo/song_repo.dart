import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

abstract class SongRepo {
  Future<Either> getNewSong();
  Future<Either> getPlayList();
  Future<Either<String, SongEntity>> getSongById(String songId);
  Future<Either> addOrRemoveFavSong(String songId);
  Future<bool> checkIfSongIsFav(String songId);
  Future<Either> getUserFavSong();
  Future<Either<String, List<SongEntity>>> searchSongs(String query);
  Future<Either<String, List<SongEntity>>> getSongsByGenre(String genre);
}
