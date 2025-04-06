import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/presentation/page/music/bloc/cubit/get_music_by_id_cubit.dart';

class MusicPlayer extends StatefulWidget {
  final String songId;

  const MusicPlayer({super.key, required this.songId});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayerService _audioPlayerService = sl<AudioPlayerService>();
  bool isPlaying = false;
  double _currentPosition = 0;
  double _totalDuration = 0;

  // Add stream subscription variables to track and cancel them
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _positionSubscription =
        _audioPlayerService.player.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inSeconds.toDouble();
      });
    });

    _durationSubscription =
        _audioPlayerService.player.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration?.inSeconds.toDouble() ?? 0;
      });
    });

    _playerStateSubscription =
        _audioPlayerService.player.playerStateStream.listen((event) {
      setState(() {
        isPlaying = event.playing;
      });
    });
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  void _playPause(String songId) {
    if (isPlaying) {
      _audioPlayerService.pause();
    } else {
      _audioPlayerService.play(songId);
    }
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return BlocProvider(
      create: (context) =>
          sl<GetMusicByIdCubit>()..fetchSongById(widget.songId),
      child: Scaffold(
        extendBodyBehindAppBar: true, // Extend body behind app bar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Image.asset(
              Appvectors.applogoBasepath,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert, color: textColor),
                onSelected: (value) {
                  switch (value) {
                    case 'Equalizer':
                      context.push('/equalizer');
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'Equalizer',
                        child: AppTextstyle(
                            text: 'Equalizer',
                            style: appStyle(
                                size: 16.sp,
                                color: textColor,
                                fontWeight: FontWeight.w500)),
                      ),
                    ])
          ],
        ),
        body: BlocBuilder<GetMusicByIdCubit, GetMusicByIdState>(
          builder: (context, state) {
            if (state is GetMusicByIdLoading) {
              return Center(
                  child: Lottie.asset(
                Appvectors.loadingAnimation,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.contain,
                repeat: true,
              ));
            } else if (state is GetMusicByIdError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is GetMusicByIdSuccess) {
              final song = state.song;
              return Stack(
                children: [
                  // Blurred background from album art
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(song.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 100.h), // Space for app bar
                        AppTextstyle(
                          text: "Now Playing",
                          style: appStyle(
                            size: 22.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Album art with shadow
                        Center(
                          child: Container(
                            height: 300.h,
                            width: 300.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.network(
                                song.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Song info
                        Text(
                          song.title,
                          style: appStyle(
                            size: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          song.artist,
                          style: appStyle(
                            size: 16.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        // Slider
                        SliderTheme(
                          data: SliderThemeData(
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 8.r),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 16.r),
                            trackHeight: 4.h,
                            activeTrackColor: AppColors.primaryColor,
                            inactiveTrackColor: Colors.white.withOpacity(0.3),
                            thumbColor: Colors.white,
                            overlayColor:
                                AppColors.primaryColor.withOpacity(0.2),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: _totalDuration > 0
                                ? _totalDuration
                                : song.duration.toDouble(),
                            value: _currentPosition < _totalDuration
                                ? _currentPosition
                                : 0,
                            onChanged: (value) {
                              _audioPlayerService
                                  .seekTo(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        // Time indicators
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_currentPosition),
                                style: appStyle(
                                  size: 12.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                _formatDuration(_totalDuration > 0
                                    ? _totalDuration
                                    : song.duration.toDouble()),
                                style: appStyle(
                                  size: 12.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Player controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.backward,
                                  size: 22.sp, color: Colors.white),
                              onPressed: () {
                                _audioPlayerService.seekTo(Duration(
                                    seconds: (_currentPosition - 10)
                                        .toInt()
                                        .clamp(0, _totalDuration.toInt())));
                              },
                            ),
                            SizedBox(width: 20.w),
                            GestureDetector(
                              onTap: () => _playPause(song.musicUrl),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isPlaying
                                      ? FontAwesomeIcons.pause
                                      : FontAwesomeIcons.play,
                                  size: 25.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.forward,
                                  size: 22.sp, color: Colors.white),
                              onPressed: () {
                                _audioPlayerService.seekTo(Duration(
                                    seconds: (_currentPosition + 10)
                                        .toInt()
                                        .clamp(0, _totalDuration.toInt())));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text('No data found.'));
          },
        ),
      ),
    );
  }
}
