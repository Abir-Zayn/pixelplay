// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/common/widgets/fav_btn.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_cubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/play_list_state_cubit.dart';

class PlayList extends StatelessWidget {
  Color color;
  PlayList({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit, PlayListStateCubit>(
        builder: (context, state) {
          if (state is PlayListStateCubitLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PlayListStateCubitError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is PlayListStateCubitSuccess) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextstyle(
                      text: "Playlist",
                      style: appStyle(
                          size: 18.sp,
                          color: color,
                          fontWeight: FontWeight.w500),
                    ),
                    AppTextstyle(
                      text: "See all",
                      style: appStyle(
                          size: 14.sp,
                          color: color,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                getSongForPlayList(state.songs),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget getSongForPlayList(List<SongEntity> songList) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: NetworkImage(songList[index].imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    // Using a property that exists in SongEntity, like title or a unique identifier
                    context.push('/musicplayer/${songList[index].id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextstyle(
                        text: songList[index].title,
                        style: appStyle(
                            size: 15.sp,
                            color: color,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      AppTextstyle(
                        text: songList[index].artist,
                        style: appStyle(
                            size: 12.sp,
                            color: color.withOpacity(0.5),
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FavBtn(songEntity: songList[index]), // Add the FavBtn widget here
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
      itemCount: songList.length,
    );
  }
}
