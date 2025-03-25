import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/model/song/songs.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/isfavSong.dart';

abstract class SongsFirebaseService {
  Future<Either> getNewSong();
  Future<Either> getPlayList();
  Future<Either<String, SongEntity>> getSongById(String songId);
  Future<Either> addOrRemoveFavSong(String songId);
  Future<bool> checkIfSongIsFav(String songId);
  Future<Either> getUserFavSong();
}

class SongsFirebaseServiceImplementation extends SongsFirebaseService {
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

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];

      var snapshot = await FirebaseFirestore.instance.collection('Songs').get();

      for (var doc in snapshot.docs) {
        var songModel = SongsModel.fromJson(doc.data());
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

  @override
  Future<Either> addOrRemoveFavSong(String songId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      late bool isFav;

      var user = auth.currentUser;
      String userId = user!.uid;

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
      return Right(isFav);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<bool> checkIfSongIsFav(String songId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      var user = auth.currentUser;
      String userId = user!.uid;

      QuerySnapshot favouriteSongList = await firestore
          .collection('Users')
          .doc(userId)
          .collection('favouriteSongs')
          .where('songId', isEqualTo: songId)
          .get();

      if (favouriteSongList.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

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
}
