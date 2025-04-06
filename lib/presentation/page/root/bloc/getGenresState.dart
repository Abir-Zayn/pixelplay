import 'package:pixelplayapp/domain/entities/song.dart';

abstract class Getgenresstate {}

class GetGenresInitialState extends Getgenresstate {}

class GetGenresLoadingState extends Getgenresstate {}

class GetGenresSuccessState extends Getgenresstate {
  final List<SongEntity> genres;
  GetGenresSuccessState(this.genres);
}

class GetGenresErrorState extends Getgenresstate {
  final String error;
  GetGenresErrorState(this.error);
}
