import 'package:bloc/bloc.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/getMusicById.dart';

part 'get_music_by_id_state.dart';

class GetMusicByIdCubit extends Cubit<GetMusicByIdState> {
  final GetSongByIdUseCase getSongByIdUseCase;


  GetMusicByIdCubit(this.getSongByIdUseCase) : super(GetMusicByIdInitial());

  void fetchSongById(String songId) async {
    emit(GetMusicByIdLoading());
    try {
      // Simulate a network call
      await Future.delayed(Duration(seconds: 1));
      // Replace with actual data fetching logic
      final result = await getSongByIdUseCase(songId);
      result.fold(
        (error) => emit(GetMusicByIdError(error)),
        (song) => emit(GetMusicByIdSuccess(song)),
      );
    } catch (e) {
      emit(GetMusicByIdError('Failed to fetch song'));
    }
  }

}
