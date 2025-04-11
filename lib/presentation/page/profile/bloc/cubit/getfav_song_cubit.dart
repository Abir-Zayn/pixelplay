import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/getFavSongs.dart';

part 'getfav_song_state.dart';

class GetfavSongCubit extends Cubit<GetfavSongState> {
  GetfavSongCubit() : super(GetfavSongInitial());

  Future<void> getUserFavSong() async {
    emit(GetfavSongLoading());
    try {
      // Simulate a network call or data fetching
      await Future.delayed(const Duration(seconds: 2));

      // Fetch the favorite songs from the repository
      final result = await sl<GetfavsongsUseCases>().call();
      result.fold(
        (error) {
          emit(GetfavSongError(errorMessage: error.toString()));
        },
        (favsongList) {
          emit(GetfavSongLoaded(favsongList: favsongList));
        },
      );
    } catch (e) {
      emit(GetfavSongError(errorMessage: e.toString()));
    }
  }

  Future<void> refreshFavSongs() async {
    // As the refresh logic is different than the initial load, therefore we will
    //skip the loading state and directly call the getUserFavSong method
    try {
      final res = await sl<GetfavsongsUseCases>().call();
      res.fold(
        (error) {
          emit(GetfavSongError(errorMessage: error.toString()));
        },
        (favsongList) {
          emit(GetfavSongLoaded(favsongList: favsongList));
        },
      );
    } catch (e) {
      emit(GetfavSongError(errorMessage: e.toString()));
    }
  }
}
