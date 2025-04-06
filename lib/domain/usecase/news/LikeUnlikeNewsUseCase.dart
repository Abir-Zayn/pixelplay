import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/repo/news_repo.dart';

class LikeUnlikeNewsUseCase {
  final NewsRepo _newsRepository;

  LikeUnlikeNewsUseCase(this._newsRepository);

  Future<Either<String, bool>> call(String newsId, bool isLike) async {
    return await _newsRepository.likeUnlikeNews(newsId, isLike);
  }
}

