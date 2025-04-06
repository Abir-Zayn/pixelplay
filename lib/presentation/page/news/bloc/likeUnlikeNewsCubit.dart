import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixelplayapp/domain/usecase/news/LikeUnlikeNewsUseCase.dart';
import 'package:pixelplayapp/domain/usecase/news/checkUserLikedNewsUseCase.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/likeUnlikeNewsState.dart';

class Likeunlikenewscubit extends Cubit<LikeUnlikeNewsState> {
  final LikeUnlikeNewsUseCase likeUnlikeNewsUseCase;
  final CheckUserLikedNewsUseCase checkUserLikedNewsUseCase;
  bool isLiked = false;
  num likeCount = 0;
  Likeunlikenewscubit(
      this.likeUnlikeNewsUseCase, this.checkUserLikedNewsUseCase)
      : super(LikeUnlikeNewsInitialState());

  Future<void> initialize(String newsId, num initialLikeCount) async {
    emit(LikeUnlikeNewsLoadingState());
    likeCount = initialLikeCount;

    // Check if the current user has already liked this news
    final result = await checkUserLikedNewsUseCase(newsId);

    result.fold((error) => emit(LikeUnlikeNewsErrorState(errorMessage: error)),
        (hasLiked) {
      isLiked = hasLiked;
      emit(LikeUnlikeNewsSuccessState(isLiked, likeCount));
    });
  }

  Future<void> toggleLike(String newsId) async {
    emit(LikeUnlikeNewsLoadingState());

    // Call the use case to toggle like
    final result = await likeUnlikeNewsUseCase(newsId, !isLiked);

    result.fold((error) => emit(LikeUnlikeNewsErrorState(errorMessage: error)),
        (isNowLiked) {
      isLiked = isNowLiked;
      likeCount =
          isNowLiked ? likeCount + 1 : (likeCount > 0 ? likeCount - 1 : 0);
      emit(LikeUnlikeNewsSuccessState(isLiked, likeCount));
    });
  }
}
