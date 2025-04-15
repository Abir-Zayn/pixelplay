import 'package:hive_flutter/hive_flutter.dart';
import 'package:pixelplayapp/data/model/song/wishlistSongs.dart';


abstract class Wishlistsongslocalstorage {
  Future<void> addToWishlist(String id);
  Future<void> removeFromWishlist(String id);
  Future<List<String>> getWishlistSongs();
}

class WishlistsongslocalstorageImpl implements Wishlistsongslocalstorage {
  final Box<Wishlistsongs> wishlistBox;

  WishlistsongslocalstorageImpl({required this.wishlistBox});

  @override
  Future<void> addToWishlist(String songId) async {
    await wishlistBox.put(
      songId,
      Wishlistsongs(id: songId, isFav: true),
    );
  }

  @override
  Future<void> removeFromWishlist(String songId) async {
    await wishlistBox.put(
      songId,
      Wishlistsongs(id: songId, isFav: false),
    );
    // Note: We keep the entry with isFav: false instead of deleting,
    // to track state consistently. Alternatively, use wishlistBox.delete(songId)
    // if you prefer removing entirely.
  }

  @override
  Future<List<String>> getWishlistSongs() async {
    return wishlistBox.values
        .where((song) => song.isFav)
        .map((song) => song.id)
        .toList();
  }
}