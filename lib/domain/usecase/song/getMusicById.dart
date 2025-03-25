// domain/usecase/songUseCase/get_song_by_id_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import '../../repo/song_repo.dart';

class GetSongByIdUseCase {
  final SongRepo songRepo;

  GetSongByIdUseCase(this.songRepo);

  Future<Either<String, SongEntity>> call(String songId) async {
    return await songRepo.getSongById(songId);
  }
}
