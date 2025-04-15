import 'package:hive_flutter/hive_flutter.dart';
import 'package:pixelplayapp/data/model/song/wishlistSongs.dart';

// Define constant for box name to avoid typos
class HiveBoxes {
  static const String wishlistSongs = 'wishlistSongs';
}

class HiveConfig {
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters only if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      // Use adapter ID if you have one defined
      Hive.registerAdapter(WishlistsongsAdapter());
    }

    // Check if box is already open before opening
    if (!Hive.isBoxOpen(HiveBoxes.wishlistSongs)) {
      await Hive.openBox<Wishlistsongs>(HiveBoxes.wishlistSongs);
    }
  }

  // Helper method to get the wishlist box
  static Box<Wishlistsongs> getWishlistBox() {
    return Hive.box<Wishlistsongs>(HiveBoxes.wishlistSongs);
  }

  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}
