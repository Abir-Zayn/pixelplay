part of 'search_song_cubit.dart';

abstract class SearchSongState {}

final class SearchSongInitial extends SearchSongState {}

class SearchLoading extends SearchSongState {}

class SearchSongSuccess extends SearchSongState {
  final List<SongEntity> songs;
  SearchSongSuccess(this.songs);
}

class SearchSongError extends SearchSongState {
  final String message;
  SearchSongError(this.message);
}
