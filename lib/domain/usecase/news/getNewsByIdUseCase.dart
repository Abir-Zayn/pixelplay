import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';
import 'package:pixelplayapp/domain/repo/news_repo.dart';

class GetnewsbyIdUseCase {
  final NewsRepo newsRepository;

  GetnewsbyIdUseCase(this.newsRepository);

  Future<Either<String, Newsentity>> call(String newsId) async {
    return await newsRepository.getNewsById(newsId);
  }
}
