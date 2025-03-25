import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/usecase/song/getPlayListUseCase.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_state_cubit.dart';

class PlayListCubit extends Cubit<PlayListStateCubit> {
  PlayListCubit() : super(PlayListStateCubitInitial());

  Future<void> getPlayList() async {
    var returnedPlayList = await sl<Getplaylistusecase>().call();
    returnedPlayList.fold(
      (left) {
        emit(PlayListStateCubitError(left.toString()));
      },
      (playList) {
        emit(PlayListStateCubitSuccess(playList));
      },
    );
  }
}
