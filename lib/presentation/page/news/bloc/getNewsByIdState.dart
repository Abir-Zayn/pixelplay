import 'package:pixelplayapp/domain/entities/newsEntity.dart';

abstract class GetnewsbyIdState {}

class GetnewsbyIdInitial extends GetnewsbyIdState {}

class GetnewsbyIdLoading extends GetnewsbyIdState {}

class GetnewsbyIdLoaded extends GetnewsbyIdState {
  final Newsentity news;
  GetnewsbyIdLoaded(this.news);
}

class GetnewsbyIdError extends GetnewsbyIdState {
  final String error;
  GetnewsbyIdError(this.error);
}
