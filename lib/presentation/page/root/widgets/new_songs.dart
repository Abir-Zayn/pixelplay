// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/new_song_cubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/new_song_state_cubit.dart';

class NewSongs extends StatelessWidget {
  Color color;
  final Function(SongEntity, bool) onSongPlayed;

  NewSongs({
    super.key,
    required this.color,
    required this.onSongPlayed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => NewSongCubit()..getNewSongs(),
        child: SizedBox(
          child: BlocBuilder<NewSongCubit, NewSongStateCubit>(
            builder: (context, state) {
              //Loading state
              if (state is NewSongStateCubitLoading) {
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
              }
              //Error state
              else if (state is NewSongStateCubitError) {
                return Center(child: Text(state.error));
              }
              //Success state -> Fetch the songs
              else if (state is NewSongStateCubitSuccess) {
                return _songs(state.songs);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ));
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Using a property that exists in SongEntity, like title or a unique identifier
                  onSongPlayed(songs[index], true);
                  context.push('/musicplayer/${songs[index].id}');
                },
                child: Container(
                  width: 200.w,
                  height: 250
                      .h, // Increase height to make better use of available space
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                      image: NetworkImage(songs[index].imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      transform: Matrix4.translationValues(10, 10, 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.darkBackgroundColor.withOpacity(0.2)
                            : AppColors.lightBackgroundColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        FontAwesomeIcons.playCircle,
                        color: AppColors.lightGreyColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 200.w, // Match width with image container
                child: AppTextstyle(
                  text: songs[index].title,
                  style: appStyle(
                      size: 15.sp, color: color, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 200.w, // Match width with image container
                child: AppTextstyle(
                  text: songs[index].artist,
                  style: appStyle(
                      size: 12.sp, color: color, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 25.w,
          );
        },
        itemCount: songs.length);
  }
}
