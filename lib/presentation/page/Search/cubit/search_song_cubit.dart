import 'package:bloc/bloc.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/searchSongUseCase.dart';

part 'search_song_state.dart';

class SearchSongCubit extends Cubit<SearchSongState> {
  final SearchSongUseCase searchSongUseCase;

  SearchSongCubit(this.searchSongUseCase) : super(SearchSongInitial());

  Future<void> searchSongs(String query) async {
    emit(SearchLoading());
    final result = await searchSongUseCase(query);
    result.fold(
      (error) => emit(SearchSongError(error)),
      (songs) => emit(SearchSongSuccess(songs)),
    );
  }
}
