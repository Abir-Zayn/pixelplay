import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/repo/news_repo.dart';

class CheckUserLikedNewsUseCase {
  final NewsRepo newsRepository;

  CheckUserLikedNewsUseCase(this.newsRepository);

  Future<Either<String, bool>> call(String newsId) async {
    return await newsRepository.checkUserLikedNews(newsId);
  }
}
