import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class GetSongsByGenreUseCase implements Usecase<Either<String, List<SongEntity>>, String> {
  GetSongsByGenreUseCase(SongRepo songRepo);

  @override
  Future<Either<String, List<SongEntity>>> call({String? params}) async {
    return await sl<SongRepo>().getSongsByGenre(params!);
  }
}