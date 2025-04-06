import 'package:pixelplayapp/domain/entities/newsEntity.dart';

abstract class GetAllNewsListState {}

class GetAllNewsListStateInitial extends GetAllNewsListState {}

class GetAllNewsListStateLoading extends GetAllNewsListState {}

class GetAllNewsListStateSuccess extends GetAllNewsListState {
  final List<Newsentity> news;
  GetAllNewsListStateSuccess(this.news);
}

class GetAllNewsListStateError extends GetAllNewsListState {
  final String error;
  GetAllNewsListStateError(this.error);
}
