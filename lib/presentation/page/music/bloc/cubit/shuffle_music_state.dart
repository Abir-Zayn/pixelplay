part of 'shuffle_music_cubit.dart';

abstract class ShuffleMusicState {}

final class ShuffleMusicInitial extends ShuffleMusicState {}

final class ShuffleMusicLoading extends ShuffleMusicState {}

final class ShuffleMusicSuccess extends ShuffleMusicState {
  final List<SongEntity> songs;

  ShuffleMusicSuccess(this.songs);
}

final class ShuffleMusicError extends ShuffleMusicState {
  final String error;

  ShuffleMusicError(this.error);
}
