import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pixelplayapp/domain/usecase/song/getSongsbyGenre.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getGenresState.dart';

class Getgenrescubit extends Cubit< Getgenresstate> {
  final GetSongsByGenreUseCase _getSongsByGenreUseCase;
  Getgenrescubit(this._getSongsByGenreUseCase) : super(GetGenresInitialState());

  static Getgenrescubit get(context) => BlocProvider.of<Getgenrescubit>(context);
  Future<void> getGenres(String genre) async {
    emit(GetGenresLoadingState());
    final result = await _getSongsByGenreUseCase.call(params: genre);
    result.fold(
      (error) => emit(GetGenresErrorState(error)),
      (genres) => emit(GetGenresSuccessState(genres)),
    );
  }
}