import 'package:pixelplayapp/domain/entities/song.dart';

abstract class PlayListStateCubit {}

class PlayListStateCubitInitial extends PlayListStateCubit {}

class PlayListStateCubitLoading extends PlayListStateCubit {}

class PlayListStateCubitSuccess extends PlayListStateCubit {
  final List<SongEntity> songs;
  PlayListStateCubitSuccess(this.songs);
}

class PlayListStateCubitError extends PlayListStateCubit {
  final String error;
  PlayListStateCubitError(this.error);
}
