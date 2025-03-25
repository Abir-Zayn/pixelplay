part of 'get_music_by_id_cubit.dart';

@immutable
sealed class GetMusicByIdState {}

final class GetMusicByIdInitial extends GetMusicByIdState {}

final class GetMusicByIdLoading extends GetMusicByIdState {}

final class GetMusicByIdSuccess extends GetMusicByIdState {
  final SongEntity song;

  GetMusicByIdSuccess(this.song);
}

final class GetMusicByIdError extends GetMusicByIdState {
  final String error;

  GetMusicByIdError(this.error);
}
