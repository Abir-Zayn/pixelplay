import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/Search/cubit/search_song_cubit.dart';

class SongSearch extends StatelessWidget {
  final SearchSongState state;

  const SongSearch({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;
    if (state is SearchSongInitial) {
      return Center(
        child: Center(
          child: AppTextstyle(
            text: 'Search for your favorite songs',
            style: appStyle(
                size: 20.sp, color: color, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (state is SearchLoading) {
      return Center(
        child: Center(
          child: Lottie.asset(
            Appvectors.loadingAnimation,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      );
    } else if (state is SearchSongSuccess) {
      final songs = (state as SearchSongSuccess).songs;
      if (songs.isEmpty) {
        return Center(
            child: AppTextstyle(
          text:
              'We are sorry that the song you are looking for is not available',
          style:
              appStyle(size: 20.sp, color: color, fontWeight: FontWeight.w500),
          maxLines: 3,
        ));
      }
      return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            onTap: () {
              // Handle song tap => Navigate to song details page
              context.push('/musicplayer/${songs[index].id}');
            },
            leading: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: NetworkImage(song.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: AppTextstyle(
              text: song.title,
              style: appStyle(
                  size: 22.sp, color: color, fontWeight: FontWeight.w500),
            ),
            subtitle: AppTextstyle(
              text: song.artist,
              style: appStyle(
                  size: 17.sp, color: color, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              song.isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          );
        },
      );
    } else if (state is SearchSongError) {
      return Center(child: Text((state as SearchSongError).message));
    }
    return const SizedBox.shrink();
  }
}
