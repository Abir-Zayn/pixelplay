import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/data/model/news/newsmodel.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';

abstract class NewsFirebaseService {
  Future<Either> getAllNews();
  Future<Either<String, Newsentity>> getNewsById(String newsId);
  Future<Either<String, bool>> likeUnlikeNews(String newsId, bool isLike);
  Future<Either<String, bool>> checkUserLikedNews(String newsId);
}

class NewsFirebaseServiceImpl extends NewsFirebaseService {
  // FirebaseAuth instance to handle authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FirebaseFirestore instance to handle Firestore database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // getAllNews method to fetch all news from Firestore
  // This method returns a list of Newsentity objects wrapped in an Either type
  // If successful, it returns Right with the list of news entities
  // If an error occurs, it returns Left with the error message
  @override
  Future<Either> getAllNews() async {
    try {
      List<Newsentity> news = [];
      var snapshot = await FirebaseFirestore.instance.collection('news').get();

      for (var doc in snapshot.docs) {
        var newsModel = NewsModel.fromJson(doc.data());
        news.add(newsModel.toEntity());
      }
      return Right(news);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // getNewsById method to fetch a specific news item by its ID from Firestore
  // This method returns a Newsentity object wrapped in an Either type
  // If successful, it returns Right with the news entity
  @override
  Future<Either<String, Newsentity>> getNewsById(String newsId) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('news').doc(newsId).get();

      if (!snapshot.exists) {
        return Left('News with ID $newsId hasn\'t found');
      }
      var newsModel = NewsModel.fromJson(snapshot.data()!);
      return Right(newsModel.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

// checkUserLikedNews method to check if the current user has liked a specific news item
// First it checks if the user is authenticated
// Checks the 'likes' subcollection for the specified news article 
// to see if the current user's ID exists[has liked] as a document

  @override
  Future<Either<String, bool>> checkUserLikedNews(String newsId) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        return Left('User not authenticated');
      }

      final userId = currentUser.uid;

      // Check if this user has already liked this news
      final likeRef = await _firestore
          .collection('news')
          .doc(newsId)
          .collection('likes')
          .doc(userId)
          .get();

      return Right(likeRef.exists);
    } catch (e) {
      return Left(e.toString());
    }
  }

// likeUnlikeNews method  is similarly checks for authenticated user then 
// within the transaction, it checks if the user has already liked the news
// If the user has liked it, it upvote the like document and increments the like count
  @override
  Future<Either<String, bool>> likeUnlikeNews(
      String newsId, bool isLike) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        return Left('User not authenticated');
      }

      final userId = currentUser.uid;
      final newsRef = _firestore.collection('news').doc(newsId);
      final userLikeRef = newsRef.collection('likes').doc(userId);

      // Check if user already liked this news
      final likeDoc = await userLikeRef.get();
      final bool hasLiked = likeDoc.exists;

      // Start a transaction to ensure atomicity
      return await _firestore
          .runTransaction<Either<String, bool>>((transaction) async {
        // Get the current news document
        final newsDoc = await transaction.get(newsRef);

        if (!newsDoc.exists) {
          return Left('News with ID $newsId not found');
        }

        // Get current like count
        num currentLikes = newsDoc.data()?['like'] ?? 0;

        if (hasLiked) {
          // User has already liked, so unlike
          transaction.delete(userLikeRef);
          transaction.update(
              newsRef, {'like': currentLikes > 0 ? currentLikes - 1 : 0});
          return Right(false);
        } else {
          // User hasn't liked yet, so like
          transaction
              .set(userLikeRef, {'timestamp': FieldValue.serverTimestamp()});
          transaction.update(newsRef, {'like': currentLikes + 1});
          return Right(true);
        }
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
