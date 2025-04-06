import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class SearchSongUseCase {
  final SongRepo songRepo;

  SearchSongUseCase(this.songRepo);

  Future<Either<String, List<SongEntity>>> call(String query) async {
    return await  songRepo.searchSongs(query);
  }
}
