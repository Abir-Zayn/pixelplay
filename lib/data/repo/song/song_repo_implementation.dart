import 'package:dartz/dartz.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/data/src/wishlistSongsLocalStorage.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/repo/song_repo.dart';

//Please Note : A huge number of lines will be modified as
//we will be dealing with Hive , The code based on hive operation will be added in the repo
// as SongFirebaseService should only be concerned with Firebase operations, modifying the backend
// handler it will violate the single responsibility principle.

class SongRepositoryImplementation extends SongRepo {
  final SongsFirebaseService songsFirebaseService;
  final Wishlistsongslocalstorage wishlistsongslocalstorage;
  SongRepositoryImplementation({
    required this.songsFirebaseService,
    required this.wishlistsongslocalstorage,
  });

  @override
  Future<Either> getNewSong() async {
    return await sl<SongsFirebaseService>().getNewSong();
  }

  @override
  Future<Either> getPlayList() async {
    try {
      //get Songs from firebase
      final res = await songsFirebaseService.getPlayList();

      if (res.isRight()) {
        //if successful , get the list of songs
        final songs = (res as Right).value as List<SongEntity>;

        //get the wishlist songs from local storage
        final wishlistSongs =
            await wishlistsongslocalstorage.getWishlistSongs();

        //update isFav status based on Local Storage
        for (var song in songs) {
          if (wishlistSongs.contains(song.id)) {
            song.isFav = true;
          }
        }
        return Right(songs);
      }

      return res;
    } catch (e) {
      //handle error
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SongEntity>> getSongById(String songId) async {
    try {
      // get song from firebase
      final res = await songsFirebaseService.getSongById(songId);

      if (res.isRight()) {
        // if successful , get the song
        final song = (res as Right).value as SongEntity;

        //get the wishlist songs from local storage
        final wishlistSongs =
            await wishlistsongslocalstorage.getWishlistSongs();

        //update isFav status based on Local Storage
        if (wishlistSongs.contains(song.id)) {
          song.isFav = true;
        }
        return Right(song);
      }
      return res;
    } catch (e) {
      return Left(e.toString());
    }

    // Commented >> return await sl<SongsFirebaseService>().getSongById(songId);
  }

  @override
  Future<Either> addOrRemoveFavSong(String songId) async {
    try {
      //check current status in local Storage
      final localWishListIds =
          await wishlistsongslocalstorage.getWishlistSongs();
      final isCurrentlyFav = localWishListIds.contains(songId);

      //perform Future positive[Success] update locally first
      if (isCurrentlyFav) {
        await wishlistsongslocalstorage.removeFromWishlist(songId);
      } else {
        await wishlistsongslocalstorage.addToWishlist(songId);
      }

      //Return Future positive[Success] update for screen to reflect the change
      final futureRes = !isCurrentlyFav;

      //Perform Firebase update in the background
      songsFirebaseService.addOrRemoveFavSong(songId).then((remoteResult) {
        if (remoteResult.isLeft()) {
          //if firebase update fails, revert local storage change
          if (isCurrentlyFav) {
            wishlistsongslocalstorage.addToWishlist(songId);
          } else {
            wishlistsongslocalstorage.removeFromWishlist(songId);
          }
          // TODO : Notify user about the error
        }
      });
      return Right(futureRes);
    } catch (e) {
      //handle error
      return Left(e.toString());
    }
    //Commented >> return await sl<SongsFirebaseService>().addOrRemoveFavSong(songId);
  }

  @override
  Future<bool> checkIfSongIsFav(String songId) async {
    try {
      // Check local storage first for immediate response
      final localWishlistIds =
          await wishlistsongslocalstorage.getWishlistSongs();
      return localWishlistIds.contains(songId);
    } catch (e) {
      // Fallback to Firebase if local check fails
      return await songsFirebaseService.checkIfSongIsFav(songId);
    }
  }

  @override
  Future<Either> getUserFavSong() async {
    try {
      //get Songs from firebase
      final res = await songsFirebaseService.getUserFavSong();

      if (res.isRight()) {
        //if successful , return the list of songs
        return res;
      }
      // If Firebase fails, try to get from local storage
      final localWishlistIds =
          await wishlistsongslocalstorage.getWishlistSongs();

      if (localWishlistIds.isEmpty) {
        //Return the empty list if no songs are found in local storage[original error]
        return res;
      }

      // Fetch songs by ID from Firebase
      List<SongEntity> favSongs = [];

      for (String id in localWishlistIds) {
        final songResult = await songsFirebaseService.getSongById(id);
        if (songResult.isRight()) {
          favSongs.add((songResult as Right).value);
        }
      }

      return Right(favSongs);
    } catch (e) {
      //handle error
      return Left(e.toString());
    }

    // return await sl<SongsFirebaseService>().getUserFavSong();
  }

  @override
  Future<Either<String, List<SongEntity>>> searchSongs(String query) async {
    return await sl<SongsFirebaseService>().searchSongs(query);
  }

  @override
  Future<Either<String, List<SongEntity>>> getSongsByGenre(String genre) async {
    return await sl<SongsFirebaseService>().getSongsByGenre(genre);
  }
}
