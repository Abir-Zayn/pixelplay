part of 'getfav_song_cubit.dart';

abstract class GetfavSongState {}

final class GetfavSongInitial extends GetfavSongState {}
final class GetfavSongLoading extends GetfavSongState {}
final class GetfavSongLoaded extends GetfavSongState {
  final List<SongEntity> favsongList;

  GetfavSongLoaded({required this.favsongList});
}
final class GetfavSongError extends GetfavSongState {
  final String errorMessage;

  GetfavSongError({required this.errorMessage});
}
