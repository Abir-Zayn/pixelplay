import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/domain/entities/song.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/SongPlayingListTile.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/all_news_list.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/genre_screen.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/new_songs.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/play_list.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage>
    with SingleTickerProviderStateMixin {
  final AudioPlayerService _audioPlayerService = sl<AudioPlayerService>();
  late TabController _tabController;
  int _currentIndex = 0;
  SongEntity? currentlyPlaying;
  bool isPlaying = false;
  late StreamSubscription<bool> _playStateSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    // Listen to play state changes
    _playStateSubscription =
        _audioPlayerService.playStateStream.listen((isPlaying) {
      setState(() {
        this.isPlaying = isPlaying;
      });
    });
  }

  void _playPause() async {
    if (currentlyPlaying == null) return;

    if (_audioPlayerService.player.playing) {
      await _audioPlayerService.pause();
    } else {
      await _audioPlayerService.play(currentlyPlaying!.musicUrl);
    }

    setState(() {
      isPlaying = !isPlaying;
    }); // Trigger rebuild to update UI
  }

  void updateCurrentlyPlaying(SongEntity song, bool isPlaying) async {
    if (isPlaying) {
      await _audioPlayerService.play(song.musicUrl);
    } else {
      await _audioPlayerService.pause();
    }
    setState(() {
      currentlyPlaying = song;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _playStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset(
          Appvectors.applogoBasepath,
          height: 80.h,
          width: 80.w,
          fit: BoxFit.contain,
        ),
      ),
      body: _buildHomeBody(textcolor),
      bottomNavigationBar: currentlyPlaying != null
          ? Songplayinglisttile(
              song: currentlyPlaying!,
              isPlaying: isPlaying,
              onTap: () {
                // Navigate to music player page
                context.push('/musicplayer/${currentlyPlaying!.id}');
              },
              onPause: _playPause,
            )
          : null,
    );
  }

  Widget _buildHomeBody(Color textcolor) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _homeArtistCard(),
              SizedBox(height: 28.h),
              _headerText(textcolor),
              SizedBox(height: 16.h),
              _tabs(textcolor),
              SizedBox(height: 22.h),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.46,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AllNewsList(
                        color: textcolor, key: const ValueKey('news-list')),
                    NewSongs(
                        onSongPlayed: updateCurrentlyPlaying,
                        color: textcolor,
                        key: const ValueKey('new-songs')),
                    GenreScreen(key: const ValueKey('Genres')),
                    Container(key: const ValueKey('artists')),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              if (_currentIndex == 1)
                PlayList(
                    onSongPlayed: updateCurrentlyPlaying, color: textcolor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText(Color textColor) {
    return AppTextstyle(
      text: "Discover",
      style: appStyle(
        size: 26.sp,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _homeArtistCard() {
    return Container(
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background gradient for visual appeal
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Content area (left side)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AppTextstyle(
                    text: "Featured Album",
                    style: appStyle(
                      size: 10.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                AppTextstyle(
                  text: "Lose Yourself",
                  style: appStyle(
                    size: 26.sp,
                    color: AppColors.lightBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    AppTextstyle(
                      text: "Eminem",
                      style: appStyle(
                        size: 14.sp,
                        color: AppColors.lightBackgroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: AppColors.lightBackgroundColor,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Artist image (right side)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: 140.w,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(18.r)),
              child: Image.asset(
                Appvectors.signinsignupImgPath2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs(Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: textColor.withOpacity(0.6),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        tabs: [
          _tabItem("News", 0),
          _tabItem("New Releases", 1),
          _tabItem("Genres", 2),
          _tabItem("Artists", 3),
        ],
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey.shade800,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    Color textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: AppTextstyle(
          text: text,
          style: appStyle(
            size: 14.sp,
            color:
                _currentIndex == index ? textcolor : textcolor.withOpacity(0.5),
            fontWeight:
                _currentIndex == index ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
