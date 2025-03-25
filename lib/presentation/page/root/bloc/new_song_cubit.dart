import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/usecase/song/songuseCase.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/new_song_state_cubit.dart';

class NewSongCubit extends Cubit<NewSongStateCubit> {
  NewSongCubit() : super(NewSongStateCubitInitial());

  Future<void> getNewSongs() async {
    var returnedSong = await sl<GetNewSongUseCase>().call();
    returnedSong.fold(
      (left) {
        emit(NewSongStateCubitError(left.toString()));
      },
      (songs) {
        emit(NewSongStateCubitSuccess(songs));
      },
    );
  }
}
