import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';

abstract class NewsRepo {
  Future<Either> getAllNews();
  Future<Either<String, Newsentity>> getNewsById(String newsId);
  Future<Either<String, bool>> likeUnlikeNews(String newsId, bool isLike);
  Future<Either<String, bool>> checkUserLikedNews(String newsId);
}
