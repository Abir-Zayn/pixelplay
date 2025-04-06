import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getGenresCubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getGenresState.dart';

class GenreSongsScreen extends StatelessWidget {
  final String genre;

  const GenreSongsScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          genre.toUpperCase(),
          style: appStyle(
            size: 20.sp,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<Getgenrescubit, Getgenresstate>(
        builder: (context, state) {
          if (state is GetGenresInitialState) {
            context.read<Getgenrescubit>().getGenres(genre);
            return _buildLoadingState();
          } else if (state is GetGenresLoadingState) {
            return _buildLoadingState();
          } else if (state is GetGenresSuccessState) {
            return _buildSongList(context, state.genres, textColor);
          } else if (state is GetGenresErrorState) {
            return _buildErrorState(textColor);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildErrorState(Color textColor) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 50.w,
              color: Colors.redAccent,
            ),
            SizedBox(height: 16.h),
            AppTextstyle(
              text: "Sorry! Something went wrong.",
              style: appStyle(
                size: 18.sp,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                context.read<Getgenrescubit>().getGenres(genre);
              },
              child: Text(
                "Try Again",
                style: appStyle(
                  size: 16.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongList(
      BuildContext context, List<SongEntity> songs, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          Text(
            "${songs.length} ${songs.length == 1 ? 'SONG' : 'SONGS'}",
            style: appStyle(
              size: 14.sp,
              color: textColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: songs.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: textColor.withOpacity(0.1),
                indent: 80.w,
              ),
              itemBuilder: (context, index) {
                final song = songs[index];
                return _buildSongItem(context, song, textColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(
      BuildContext context, SongEntity song, Color textColor) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/musicplayer/${song.id}');
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              // Album Art
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(song.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: appStyle(
                        size: 16.sp,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      song.artist,
                      style: appStyle(
                        size: 14.sp,
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Play Button
              IconButton(
                onPressed: () {
                  context.push('/musicplayer/${song.id}');
                },
                icon: Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primaryColor,
                  size: 30.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
