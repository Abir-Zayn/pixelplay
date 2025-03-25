import 'package:pixelplayapp/domain/entities/song.dart';

abstract class NewSongStateCubit {}

class NewSongStateCubitInitial extends NewSongStateCubit {}

class NewSongStateCubitLoading extends NewSongStateCubit {}

class NewSongStateCubitSuccess extends NewSongStateCubit {
  final List<SongEntity> songs;
  NewSongStateCubitSuccess(this.songs);
}

class NewSongStateCubitError extends NewSongStateCubit {
  final String error;
  NewSongStateCubitError(this.error);
}