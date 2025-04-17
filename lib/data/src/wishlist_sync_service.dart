import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pixelplayapp/data/src/songs_firebase_service.dart';
import 'package:pixelplayapp/data/src/wishlistSongsLocalStorage.dart';

class WishlistSyncService {
  final Wishlistsongslocalstorage _localStorage;
  final SongsFirebaseService _firebaseService;
  final Connectivity _connectivity;

  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  WishlistSyncService({
    required Wishlistsongslocalstorage localStorage,
    required SongsFirebaseService firebaseService,
    required Connectivity connectivity,
  })  : _localStorage = localStorage,
        _firebaseService = firebaseService,
        _connectivity = connectivity;

  // Initialize the sync service
  void initialize() {
    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // When connectivity is restored, sync pending changes
        syncPendingChanges();
      }
    });

    // Initial sync when service starts
    checkConnectivityAndSync();
  }

  // Check connectivity and sync if online
  Future<void> checkConnectivityAndSync() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      syncPendingChanges();
    }
  }

  // Sync local wishlist with Firebase
  Future<void> syncPendingChanges() async {
    if (_isSyncing) return; // Prevent multiple syncs running simultaneously

    _isSyncing = true;

    try {
      // Get local wishlist songs
      final localWishlistIds = await _localStorage.getWishlistSongs();

      // Get remote wishlist status for each song
      for (String songId in localWishlistIds) {
        final remoteIsFav = await _firebaseService.checkIfSongIsFav(songId);

        // If local and remote status don't match, update remote
        if (!remoteIsFav) {
          await _firebaseService.addOrRemoveFavSong(songId);
        }
      }

      // Get all songs that have entries in local storage (including non-favorites)
      // This requires modifying the local storage interface to get all entries
      final allLocalEntries = await _getAllLocalEntries();

      // For songs marked as not favorite locally, ensure they're removed from remote
      for (String songId in allLocalEntries
          .where((entry) => !localWishlistIds.contains(entry))) {
        final remoteIsFav = await _firebaseService.checkIfSongIsFav(songId);

        // If remote is still favorite but local is not, update remote
        if (remoteIsFav) {
          await _firebaseService.addOrRemoveFavSong(songId);
        }
      }
    } catch (e) {
      // Handle sync errors
      debugPrint('Wishlist sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // Helper method to get all entries in local storage
  // This would need to be implemented in the WishlistsongslocalstorageImpl class
  Future<List<String>> _getAllLocalEntries() async {
    // This is a placeholder - you'll need to implement this in WishlistsongslocalstorageImpl
    // It should return all song IDs in the box, regardless of isFav status
    return _localStorage.getAllSongIds();
  }

  // Dispose the sync service
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

// Extension method for WishlistsongslocalstorageImpl to get all song IDs
extension WishlistsongslocalstorageExtension on Wishlistsongslocalstorage {
  Future<List<String>> getAllSongIds() async {
    if (this is WishlistsongslocalstorageImpl) {
      final impl = this as WishlistsongslocalstorageImpl;
      return impl.wishlistBox.keys.cast<String>().toList();
    }
    return [];
  }
}
