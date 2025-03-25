import 'package:bloc/bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/usecase/song/addRemoveFav.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';

part 'fav_btn_state.dart';

class FavBtnCubit extends Cubit<FavBtnState> {
  FavBtnCubit({required String songId, bool initialFavStatus = false})
      : super(FavBtnUpdated(isFav: initialFavStatus)) {
    // Check current status when initialized
    checkFavStatus(songId);
  }
  void checkFavStatus(String sondId) async {
    final isFav = await sl<IsfavsongUseCase>().call(params: sondId);
    emit(FavBtnUpdated(isFav: isFav));
  }

  void updateFavBtn(String songId) async {
    var res = await sl<AddremovefavSongUseCase>().call(params: songId);
    res.fold((left) {}, (right) {
      // Toggle current favorite status if right is null or undefined
      if (state is FavBtnUpdated) {
        final currentStatus = (state as FavBtnUpdated).isFav;
        // If the API returned a specific value, use it, otherwise toggle
        final newStatus = right ?? !currentStatus;
        emit(FavBtnUpdated(isFav: newStatus));
      }
    });
  }
}
