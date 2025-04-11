import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/model/song/songs.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';
import 'package:pixelplayapp/presentation/page/profile/bloc/cubit/eventBus.dart';

abstract class SongsFirebaseService {
  Future<Either> getNewSong();
  Future<Either> getPlayList();
  Future<Either<String, SongEntity>> getSongById(String songId);
  Future<Either> addOrRemoveFavSong(String songId);
  Future<bool> checkIfSongIsFav(String songId);
  Future<Either> getUserFavSong();
  Future<Either<String, List<SongEntity>>> searchSongs(String query);
  Future<Either<String, List<SongEntity>>> getSongsByGenre(String genre);
}

class SongsFirebaseServiceImplementation extends SongsFirebaseService {
  @override

  // This method fetches songs from Firestore based on the genre provided.
  // It returns a list of SongEntity objects wrapped in an Either type.
  Future<Either<String, List<SongEntity>>> getSongsByGenre(String genre) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where('genre', isEqualTo: genre.toLowerCase())
          .get();

      List<SongEntity> songs = [];
      // from the snapshot, we get the data and convert it to a SongEntity object
      for (var doc in snapshot.docs) {
        var songModel = SongsModel.fromJson(doc.data());
        final isFav = await checkIfSongIsFav(songModel.id!);
        songs.add(songModel.copyWith(isFav: isFav).toEntity());
      }

      // If songs are found, return the list of songs
      return Right(songs);
    } catch (e) {
      return Left('Failed to get songs by genre: ${e.toString()}');
    }
  }

  //This method showcase the 3 random songs from the Songs collection in Firestore
  //Fetches a random set of 3 songs from the Songs collection..
  //It uses a Set to ensure that the same song is not selected multiple times.
  //Once the random indices are generated,
  //it fetches the songs from Firestore and returns them as a list of SongEntity objects.
  @override
  Future<Either> getNewSong() async {
    try {
      List<SongEntity> songs = [];
      // First, get the total count of songs (or a reasonable subset)
      var countSnapshot =
          await FirebaseFirestore.instance.collection('Songs').get();

      int totalSongs = countSnapshot.docs.length;
      Set<int> randomIndices = {};
      Random random = Random();

      while (randomIndices.length < 3) {
        int randomIndex = random.nextInt(totalSongs);
        randomIndices.add(randomIndex);
      }
      // Convert to List and sort for efficient querying
      List<int> indices = randomIndices.toList()..sort();

      // Fetch all songs and select the ones at random indices
      for (int i = 0; i < indices.length; i++) {
        var doc = countSnapshot.docs[indices[i]];
        var songModel = SongsModel.fromJson(doc.data());

        bool isFav = await sl<IsfavsongUseCase>().call(params: songModel.id);
        songModel.isFav = isFav;
        // As id has already been set in the model, we can directly use it
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // This method fetches all songs from Firestore and returns them as a list of SongEntity objects.
  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];

      var snapshot = await FirebaseFirestore.instance.collection('Songs').get();

      for (var doc in snapshot.docs) {
        var songModel = SongsModel.fromJson(doc.data());

        //check if the song is fav
        bool isFav = await checkIfSongIsFav(
          songModel.id!,
        );
        //set the isFav property in the model
        songModel.isFav = isFav;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SongEntity>> getSongById(String songId) async {
    // fetch the song by ID from Firestore
    try {
      // Get the document reference using the songId
      var docSnapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .doc(songId)
          .get();

      // Check if the document exists
      if (!docSnapshot.exists) {
        return Left('Song with ID $songId not found');
      }

      // Convert the document data to a SongEntity
      var songModel = SongsModel.fromJson(docSnapshot.data()!);
      return Right(songModel.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

// This method adds or removes a song from the user's favorite list in Firestore.
  @override
  Future<Either> addOrRemoveFavSong(String songId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      late bool isFav;

      // Get the current user from FirebaseAuth
      var user = auth.currentUser;
      String userId = user!.uid;

      // Check if the song is already in the user's favorite list
      QuerySnapshot favouriteSongList = await firestore
          .collection('Users')
          .doc(userId)
          .collection('favouriteSongs')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongList.docs.isNotEmpty) {
        await favouriteSongList.docs.first.reference.delete();
        isFav = false;
      } else {
        // If not, add it to the favorite list
        await firestore
            .collection('Users')
            .doc(userId)
            .collection('favouriteSongs')
            .add({
          'songId': songId,
          'createdAt': DateTime.now(),
        });
        isFav = true;
      }

      // Notify the user about the success of the operation
      Eventbus().notifyFavouritesChanged();
      // Return the updated favorite status
      return Right(isFav);
    } catch (e) {
      return Left(e.toString());
    }
  }

// This method checks if a song is already in the user's favorite list in Firestore.
  @override
  Future<bool> checkIfSongIsFav(String songId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the current user from FirebaseAuth
      var user = auth.currentUser;
      String userId = user!.uid;

// Check if the song is already in the user's favorite list
      QuerySnapshot favouriteSongList = await firestore
          .collection('Users')
          .doc(userId)
          .collection('favouriteSongs')
          .where('songId', isEqualTo: songId)
          .get();

// If the song is found in the favorite list, return true
      if (favouriteSongList.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

// This method fetches the user's favorite songs from Firestore and returns them as a list of SongEntity objects.
  @override
  Future<Either> getUserFavSong() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      var user = auth.currentUser;
      String userId = user!.uid;
      List<SongEntity> favSongs = [];

      QuerySnapshot favSongSnapShot = await firestore
          .collection("Users")
          .doc(userId)
          .collection("favouriteSongs")
          .get();

      for (var ele in favSongSnapShot.docs) {
        var songId = ele['songId'];
        var song = await firestore.collection('Songs').doc(songId).get();
        SongsModel songsModel = SongsModel.fromJson(song.data()!);
        favSongs.add(songsModel.toEntity());
      }

      return Right(favSongs);
    } catch (e) {
      return Left(e.toString());
    }
  }

// This method searches for songs in Firestore based on a query string.
// Search is performed using the 'searchOpt' field in the Songs collection.
// SearchOpt is basically a lowercased version of the song name with spaces removed.
// If no exact matches are found, it tries to find partial matches.
  @override
  Future<Either<String, List<SongEntity>>> searchSongs(String query) async {
    try {
      if (query.isEmpty) {
        return Left('Query cannot be empty');
      }

      //removing the spaces from the query
      final searchOptQuery = query.replaceAll(RegExp(r'\s+'), '').toLowerCase();

      // Search using the searchOpt field
      var snapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where('searchOpt', isEqualTo: searchOptQuery)
          .get();

      // partial match
      // If no exact matches, try partial match
      if (snapshot.docs.isEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('Songs')
            .where('searchOpt', isGreaterThanOrEqualTo: searchOptQuery)
            .where('searchOpt', isLessThan: '$searchOptQuery\uf8ff')
            .get();
      }

      //Process the result
      List<SongEntity> songs = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final songModel = SongsModel.fromJson(data);
        final isFav = await checkIfSongIsFav(songModel.id!);
        songs.add(songModel.copyWith(isFav: isFav).toEntity());
      }

      return Right(songs);
    } catch (e) {
      return Left('Search failed: ${e.toString()}');
    }
  }
}
