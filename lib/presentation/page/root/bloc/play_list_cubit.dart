import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/domain/usecase/song/getPlayListUseCase.dart';
import 'package:pixelplayapp/presentation/page/profile/bloc/cubit/eventBus.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_state_cubit.dart';

class PlayListCubit extends Cubit<PlayListStateCubit> {
  late StreamSubscription _favoriteSubscription;

  PlayListCubit() : super(PlayListStateCubitInitial()) {
    // Listen for favorite changes
    _favoriteSubscription = Eventbus().onFavoritesChanged.listen((_) {
      // Refresh the playlist when favorites change
      getPlayList();
    });
  }

  @override
  Future<void> close() {
    // Cancel subscription when cubit is closed
    _favoriteSubscription.cancel();
    return super.close();
  }

  Future<void> getPlayList() async {
    try {
      emit(PlayListStateCubitLoading());
      // Fetch the playlist from the repository
      final result = await sl<Getplaylistusecase>().call();
      result.fold(
        (error) {
          emit(PlayListStateCubitError(error.toString()));
        },
        (playList) {
          emit(PlayListStateCubitSuccess(playList));
        },
      );
    } catch (e) {
      emit(PlayListStateCubitError(e.toString()));
    }
  }
}
