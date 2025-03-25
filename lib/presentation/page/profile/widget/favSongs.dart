// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/common/widgets/fav_btn.dart';
import 'package:pixelplayapp/presentation/page/profile/bloc/cubit/getfav_song_cubit.dart';

class GetFavSongWidget extends StatefulWidget {
  Color textColor;
  GetFavSongWidget({
    super.key,
    required this.textColor,
  });

  @override
  State<GetFavSongWidget> createState() => _GetFavSongWidgetState();
}

class _GetFavSongWidgetState extends State<GetFavSongWidget> {
  // Define a variable to hold the text color based on the theme

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetfavSongCubit()..getUserFavSong(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextstyle(
              text: "Songs you loved it",
              style: appStyle(
                  size: 18.sp,
                  color: widget.textColor,
                  fontWeight: FontWeight.w500),
            ),
            BlocBuilder<GetfavSongCubit, GetfavSongState>(
              builder: (context, state) {
                if (state is GetfavSongLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetfavSongError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 1),
                        content: AppTextstyle(
                          text: state.errorMessage,
                          style: appStyle(
                              size: 12.sp,
                              color: widget.textColor,
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                        ),
                      ),
                    );
                  });
                }
                if (state is GetfavSongLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
                    itemCount: state.favsongList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 25.w),
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      state.favsongList[index].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Using a property that exists in SongEntity, like title or a unique identifier
                                context.push(
                                    '/musicplayer/${state.favsongList[index].id}');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextstyle(
                                    text: state.favsongList[index].title,
                                    style: appStyle(
                                        size: 16.sp,
                                        color: widget.textColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  AppTextstyle(
                                    text: state.favsongList[index].artist,
                                    style: appStyle(
                                        size: 12.sp,
                                        color:
                                            widget.textColor.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            FavBtn(songEntity: state.favsongList[index]),
                          ],
                        ),
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
