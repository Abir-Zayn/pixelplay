import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/wishlistSongsLocalStorage.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/domain/usecase/song/addRemoveFav.dart';

class FavBtn extends StatefulWidget {
  final SongEntity songEntity;

  const FavBtn({super.key, required this.songEntity});

  @override
  State<FavBtn> createState() => _FavBtnState();
}

class _FavBtnState extends State<FavBtn> {
  // Local state variable to control the UI directly
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    // Initialize with the song's current status
    _isFav = widget.songEntity.isFav;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFav ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
        color: _isFav ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        // STEP 1: Immediately update UI state
        setState(() {
          _isFav = !_isFav;
          widget.songEntity.isFav = _isFav; // Update the entity too
        });

        // STEP 2: Trigger the backend update in a separate isolate
        Future(() async {
          try {
            // Get local storage
            final localStorage = sl<Wishlistsongslocalstorage>();

            // Update local storage
            if (_isFav) {
              await localStorage.addToWishlist(widget.songEntity.id);
            } else {
              await localStorage.removeFromWishlist(widget.songEntity.id);
            }

            // Trigger Firebase update
            final result = await sl<AddremovefavSongUseCase>()
                .call(params: widget.songEntity.id);

            // Handle potential errors
            result.fold((error) {
              // If Firebase update fails, revert UI on next frame
              if (mounted) {
                setState(() {
                  _isFav = !_isFav;
                  widget.songEntity.isFav = _isFav;
                });
              }
            }, (success) {
              // Success case - nothing needed as UI is already updated
            });
          } catch (e) {
            // Error handling
            print('Error updating favorite status: $e');
          }
        });
      },
    );
  }
}
