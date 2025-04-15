import 'package:bloc/bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/wishlistSongsLocalStorage.dart';
import 'package:pixelplayapp/domain/usecase/song/addRemoveFav.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';
// No need to import EventBus here as it's already notified in the Firebase service

part 'fav_btn_state.dart';

class FavBtnCubit extends Cubit<FavBtnState> {
  final Wishlistsongslocalstorage _localStorage =
      sl<Wishlistsongslocalstorage>();

  FavBtnCubit({required String songId, bool initialFavStatus = false})
      : super(FavBtnUpdated(isFav: initialFavStatus)) {
    // Check current status when initialized
    checkFavStatus(songId);
  }

  void checkFavStatus(String sondId) async {
    try {
      //First check local storage for immediate response
      final localWishListIds = await _localStorage.getWishlistSongs();
      final isLocalFav = localWishListIds.contains(sondId);
      emit(FavBtnUpdated(isFav: isLocalFav));
    } catch (e) {
      // If local check fails, fallback to Firebase
      final isFav = await sl<IsfavsongUseCase>().call(params: sondId);
      emit(FavBtnUpdated(isFav: isFav));
    }

    // final isFav = await sl<IsfavsongUseCase>().call(params: sondId);
    // emit(FavBtnUpdated(isFav: isFav));
  }

  void updateFavBtn(String songId) async {
    // Get current status
    final currentStatus =
        state is FavBtnUpdated ? (state as FavBtnUpdated).isFav : false;
    // Immediately emit the new state (optimistic update)
    final newStatus = !currentStatus;
    emit(FavBtnUpdated(isFav: newStatus));

    // Update local storage immediately
    try {
      if (newStatus) {
        await _localStorage.addToWishlist(songId);
      } else {
        await _localStorage.removeFromWishlist(songId);
      }
    } catch (e) {
      // If local update fails, revert UI state
      emit(FavBtnUpdated(isFav: currentStatus));
      return;
    }

  //perform the API call in the background
  var res = await sl<AddremovefavSongUseCase>().call(params: songId);
  res.fold(
    (left){
      // If API call fails, revert to previous state
      emit(FavBtnUpdated(isFav: currentStatus));
      //TODO :: Optionally show an error message

      // Also revert local storage
      if (currentStatus) {
        _localStorage.addToWishlist(songId);
      } else {
        _localStorage.removeFromWishlist(songId);
      }

    }, (right){
        //If API call is successful, for cross check ensure the UI has match
        if(right != null && right != newStatus){
          emit(FavBtnUpdated(isFav: right));

          //Also update local storage to match
          if(right){
            _localStorage.addToWishlist(songId);
        }else{
            _localStorage.removeFromWishlist(songId);
          }
        }
    }
  );




    // var res = await sl<AddremovefavSongUseCase>().call(params: songId);
    // res.fold((left) {}, (right) {
    //   // Toggle current favorite status if right is null or undefined
    //   if (state is FavBtnUpdated) {
    //     final currentStatus = (state as FavBtnUpdated).isFav;
    //     // If the API returned a specific value, use it, otherwise toggle
    //     final newStatus = right ?? !currentStatus;
    //     emit(FavBtnUpdated(isFav: newStatus));
    //   }
    // });
  }
}
