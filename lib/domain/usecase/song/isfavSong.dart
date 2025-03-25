import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/usecase/usecase.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

class IsfavsongUseCase implements Usecase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<SongRepo>().checkIfSongIsFav(params!);
  }
}
