import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/domain/entities/song.dart';

class Songplayinglisttile extends StatefulWidget {
  final SongEntity song;
  final VoidCallback onTap;
  final VoidCallback onPause;
  final bool isPlaying;
  const Songplayinglisttile(
      {super.key,
      required this.song,
      required this.onTap,
      required this.onPause,
      required this.isPlaying});

  @override
  State<Songplayinglisttile> createState() => _SongplayinglisttileState();
}

class _SongplayinglisttileState extends State<Songplayinglisttile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Song thumbnail
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(widget.song.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Song info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextstyle(
                      text: widget.song.title,
                      style: appStyle(
                        size: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    AppTextstyle(
                      text: widget.song.artist,
                      style: appStyle(
                        size: 12.sp,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Play/Pause button
              IconButton(
                onPressed: () {
                  setState(() {
                    //if the song is playing, pause it
                    if (widget.isPlaying) {
                      widget.onPause();
                    } else {
                      widget.onTap();
                    }
                  });
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    key: ValueKey<bool>(
                        widget.isPlaying), // Important for animation
                    color: Colors.white,
                    size: 32.w,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
