import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/news_firebase_service.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';
import 'package:pixelplayapp/domain/repo/news_repo.dart';

class NewsRepoImpl extends NewsRepo {
  @override
  Future<Either> getAllNews() async {
    return await sl<NewsFirebaseService>().getAllNews();
  }

  @override
  Future<Either<String, Newsentity>> getNewsById(String newsId) async {
    return await sl<NewsFirebaseService>().getNewsById(newsId);
  }

  @override
  Future<Either<String, bool>> likeUnlikeNews(
      String newsId, bool isLike) async {
    return await sl<NewsFirebaseService>().likeUnlikeNews(newsId, isLike);
  }

  @override
  Future<Either<String, bool>> checkUserLikedNews(String newsId) async {
    return await sl<NewsFirebaseService>().checkUserLikedNews(newsId);
  }
}
