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
import 'package:pixelplayapp/presentation/page/music/bloc/cubit/shuffle_music_cubit.dart';

// A Screen UI that displays the music player interface
// It includes a play/pause button, a slider for seeking,
//and displays the current and total duration of the song.
// It also shows the album art and song information.
class MusicPlayer extends StatefulWidget {
  final String songId;

  const MusicPlayer({super.key, required this.songId});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  // Initialize the audio player service using service locator
  // This service is responsible for handling audio playback
  // Initialize the shuffle music cubit
  final AudioPlayerService _audioPlayerService = sl<AudioPlayerService>();
  final ShuffleMusicCubit _shuffleMusicCubit = sl<ShuffleMusicCubit>();

  // Variables to track the current state of the player
  bool isPlaying = false;
  double _currentPosition = 0;
  double _totalDuration = 0;
  String _currentSongID = "";

  // Add stream subscription variables to track the audio player's position
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<String> _currentSongSubscription;

  // Initialize the audio player state and duration streams
  @override
  void initState() {
    super.initState();
    //Initialize current Song ID
    _currentSongID = widget.songId;
    _positionSubscription =
        _audioPlayerService.player.positionStream.listen((position) {
      setState(() {
        _currentPosition =
            position.inSeconds.toDouble(); // Update current position
      });
    });

    _durationSubscription =
        _audioPlayerService.player.durationStream.listen((duration) {
      setState(() {
        _totalDuration =
            duration?.inSeconds.toDouble() ?? 0; // Update total duration
      });
    });

    _playerStateSubscription =
        _audioPlayerService.player.playerStateStream.listen((event) {
      setState(() {
        isPlaying = event.playing; // Update play/pause state

        //if the song has completed its circle then play the next song
        if (event.processingState == ProcessingState.completed) {
          _audioPlayerService.playNext();
        }
      });
    });

    //Add subscription to current song change
    _currentSongSubscription =
        _audioPlayerService.currentSongStream.listen((songId) {
      setState(() {
        _currentSongID = songId; // Update current song ID
        _reloadSongDetails();
      });
    });
  }

  void _reloadSongDetails() {
    if (_currentSongID != widget.songId) {
      context.push('/musicplayer/$_currentSongID');
    }
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions
    _shuffleMusicCubit.close();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _playerStateSubscription.cancel();
    _currentSongSubscription.cancel(); // Cancel the new subscription
    super.dispose();
  }

  //Toogle between play and pause state
  void _playPause(String songId) {
    if (isPlaying) {
      _audioPlayerService.pause();
    } else {
      _audioPlayerService.play(songId);
    }
  }

  void shuffleMusic() {
    // Shuffle the music playlist
    _shuffleMusicCubit.shufflePlaylist();
  }

  // Format the duration from seconds to mm:ss format
  // This is used to display total duration of the song
  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    //Picking the text color based on the theme brightness
    Color textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<GetMusicByIdCubit>()..fetchSongById(widget.songId),
        ),
        BlocProvider(
          create: (context) => sl<ShuffleMusicCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShuffleMusicCubit, ShuffleMusicState>(
            listener: (context, state) {
              if (state is ShuffleMusicError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: AppTextstyle(
                      text: 'Error: ${state.error}',
                      style: appStyle(
                          size: 15.sp,
                          color: textColor,
                          fontWeight: FontWeight.w400),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          extendBodyBehindAppBar: true, // Extend body behind app bar
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Center(
              child: Image.asset(
                Appvectors.applogoBasepath, // App logo
                height: 50.h,
                width: 50.w,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              //Equalizer navigation button
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
                // Show loading animation while fetching data
                return Center(
                    child: Lottie.asset(
                  Appvectors.loadingAnimation,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.contain,
                  repeat: true,
                ));
                //Error State
              } else if (state is GetMusicByIdError) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is GetMusicByIdSuccess) {
                // Success state, song stores the data generated by the state/cubit
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
                      //Blur effect with Dark overlay
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
                              height: MediaQuery.of(context).size.width * 0.72,
                              width: MediaQuery.of(context).size.width * 0.60,
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
                                        value: progress.expectedTotalBytes !=
                                                null
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
                          AppTextstyle(
                            text: song.artist,
                            style: appStyle(
                              size: 16.sp,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          // Slider

                          // This slider allows the user to seek through the song
                          // It updates the current position of the song as it plays
                          SliderTheme(
                            data: SliderThemeData(
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8.r),
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
                                AppTextstyle(
                                  text: _formatDuration(_currentPosition),
                                  style: appStyle(
                                    size: 12.sp,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                AppTextstyle(
                                  text: _formatDuration(_totalDuration > 0
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Shuffle Feature builder
                              BlocBuilder<ShuffleMusicCubit, ShuffleMusicState>(
                                  builder: (context, state) {
                                bool isActive =
                                    _audioPlayerService.isShuffleMode;
                                return IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.shuffle,
                                    size: 12.sp,
                                    color: isActive
                                        ? Colors.amberAccent
                                        : AppColors.lightBackgroundColor,
                                  ),
                                  onPressed: () {
                                    if (state is! ShuffleMusicLoading) {
                                      _shuffleMusicCubit.shufflePlaylist();
                                      //Toggle shuffle mode directly in the service.
                                      _audioPlayerService.toggleShuffleMode();
                                      setState(() {
                                        isActive =
                                            _audioPlayerService.isShuffleMode;
                                      });
                                    }
                                  },
                                );
                              }),

                              //10 seconds backward button
                              IconButton(
                                icon: Icon(FontAwesomeIcons.backwardFast,
                                    size: 25.sp, color: Colors.white),
                                onPressed: () {
                                  _audioPlayerService.seekTo(Duration(
                                      seconds: (_currentPosition - 10)
                                          .toInt()
                                          .clamp(0, _totalDuration.toInt())));
                                },
                              ),
                              SizedBox(width: 20.w),

                              // Play/Pause button
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
                                    size: 30.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),

                              //10 seconds forward button
                              IconButton(
                                icon: Icon(FontAwesomeIcons.forwardFast,
                                    size: 25.sp, color: Colors.white),
                                onPressed: () {
                                  _audioPlayerService.seekTo(Duration(
                                      seconds: (_currentPosition + 10)
                                          .toInt()
                                          .clamp(0, _totalDuration.toInt())));
                                },
                              ),

                              GestureDetector(
                                onTap: () {
                                  // Navigate to the playlist screen
                                },
                                child: Icon(
                                  FontAwesomeIcons.list,
                                  size: 12.sp,
                                  color: AppColors.lightBackgroundColor,
                                ),
                              )
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
      ),
    );
  }
}
