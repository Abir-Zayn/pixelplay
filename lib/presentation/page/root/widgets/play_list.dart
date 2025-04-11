import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/common/widgets/fav_btn.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_cubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_state_cubit.dart';

class PlayList extends StatefulWidget {
  final Color color;
  final Function(SongEntity, bool) onSongPlayed;

  const PlayList({
    super.key,
    required this.color,
    required this.onSongPlayed,
  });

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit, PlayListStateCubit>(
        builder: (context, state) {
          if (state is PlayListStateCubitLoading) {
            return FutureBuilder<Widget>(
              future: _buildLoadingState(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data!;
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          } else if (state is PlayListStateCubitError) {
            return _buildErrorState(state.error);
          } else if (state is PlayListStateCubitSuccess) {
            return _buildSuccessState(context, state.songs);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<Widget> _buildLoadingState() async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return Center(
        child: Lottie.asset(
          Appvectors.loadingAnimation,
          width: 100.w,
          height: 100.h,
          fit: BoxFit.contain,
          repeat: true,
        ),
      );
    });
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            error,
            style: appStyle(
              size: 16.sp,
              color: widget.color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, List<SongEntity> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextstyle(
                text: "Discover Music",
                style: appStyle(
                  size: 22.sp,
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle "See All" action
                },
                child: Text(
                  "See All",
                  style: appStyle(
                    size: 14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildSongList(context, songs),
      ],
    );
  }

  Widget _buildSongList(BuildContext context, List<SongEntity> songList) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: songList.length,
          separatorBuilder: (context, index) => Divider(
            height: 1.h,
            thickness: 0.5,
            color: widget.color.withOpacity(0.1),
            indent: 72.w, // Match image width + padding
            endIndent: 16.w,
          ),
          itemBuilder: (context, index) {
            return _buildSongItem(context, songList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, SongEntity song) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onSongPlayed(song, true);
          context.push('/musicplayer/${song.id}');
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Album Art with Number Indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: song.imageUrl.isEmpty
                            ? NetworkImage('https://placehold.co/600x400/png')
                            : NetworkImage(song.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),

              // Song Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextstyle(
                      text: song.title,
                      style: appStyle(
                        size: 16.sp,
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    AppTextstyle(
                      text: song.artist,
                      style: appStyle(
                        size: 13.sp,
                        color: widget.color.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite Button and Duration
              Column(
                children: [
                  FavBtn(songEntity: song),
                  SizedBox(height: 4.h),
                  AppTextstyle(
                    text: _formatDuration(song.duration.toDouble()),
                    style: appStyle(
                      size: 12.sp,
                      color: widget.color.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(double minutes) {
    final totalSeconds = (minutes * 60).round(); // Convert to seconds
    final duration = Duration(seconds: totalSeconds);
    final mins = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }
}
