abstract class LikeUnlikeNewsState {}

class LikeUnlikeNewsInitialState extends LikeUnlikeNewsState {}

class LikeUnlikeNewsLoadingState extends LikeUnlikeNewsState {}

class LikeUnlikeNewsSuccessState extends LikeUnlikeNewsState {
  final bool isLiked;
  final num likeCount;

  LikeUnlikeNewsSuccessState(this.isLiked, this.likeCount);
}

class LikeUnlikeNewsErrorState extends LikeUnlikeNewsState {
  final String errorMessage;
  LikeUnlikeNewsErrorState({required this.errorMessage});
}
