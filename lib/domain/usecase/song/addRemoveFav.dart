
import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class AddremovefavSongUseCase implements Usecase<Either,String>{

  @override
  Future<Either>call ({String? params}) async{
    return await sl<SongRepo>().addOrRemoveFavSong(params!);
  }
}