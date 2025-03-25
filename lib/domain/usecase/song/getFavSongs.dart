import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class GetfavsongsUseCases implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<SongRepo>().getUserFavSong();
  }
}
