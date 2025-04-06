import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';

// This page is for the Equalizer settings of the music player.
// It allows users to enable/disable the equalizer and select audio presets.
// The page uses the EqualizerFlutter package and perform similar like device's equalizer.
class EqualizerPage extends StatefulWidget {
  const EqualizerPage({super.key});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  //state variables
  // equalizerEnabled: to check if the equalizer is enabled or not
  bool equalizerEnabled = false;

  // selectedPreset: to store the currently selected preset
  String? selectedPreset;

  // audioService: to access the audio player service
  final AudioPlayerService audioService = sl<AudioPlayerService>();

  //Future to lead equalizer presets
  late Future<List<String>> presetsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the equalizer with audio session ID 0
    EqualizerFlutter.init(0);

    // Load available presets names from the equalizer
    presetsFuture = EqualizerFlutter.getPresetNames();
  }

  @override
  void dispose() {
    // Release the equalizer when the page is disposed
    EqualizerFlutter.release();
    super.dispose();
  }

  // This page doesnt follow the principle of ThemeData and ThemeMode
  // As I have declared the background color in the appBar and body to black
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar with title 'Equalizer'
      appBar: AppBar(
        title: AppTextstyle(
            text: 'Equalizer',
            style: appStyle(
                size: 20.sp, color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.black,
      ),
      //Body with black background color
      backgroundColor: Colors.black87,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView(
          children: [
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SwitchListTile(
                title: Text('Enable Equalizer',
                    style: appStyle(
                        size: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                value: equalizerEnabled,
                onChanged: (value) {
                  EqualizerFlutter.setEnabled(value);
                  setState(() {
                    equalizerEnabled = value;
                  });
                },
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              'Audio Presets',
              style: appStyle(
                  size: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            _buildPresetSelector(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

// By the name convention, this function is used to build the preset selector

  Widget _buildPresetSelector() {
    return FutureBuilder<List<String>>(
      // FutureBuilder to load the presets
      // The future is the list of presets loaded from the equalizer
      future: presetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              Appvectors.loadingAnimation,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
              repeat: true,
              frameRate: FrameRate(60),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: AppTextstyle(
              text: 'Error loading presets: ${snapshot.error}',
              style: appStyle(
                  size: 14.sp, color: Colors.red, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          );
        }

        final presets = snapshot.data ?? [];
        // Empty state
        if (presets.isEmpty) {
          return Center(
            child: AppTextstyle(
              text: 'No presets available',
              style: appStyle(
                  size: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Build list of preset options
        return Column(
          children: presets.map((preset) => _buildPresetTile(preset)).toList(),
        );
      },
    );
  }

  /// Builds an individual preset selection tile
  Widget _buildPresetTile(String preset) {
    bool isSelected = selectedPreset == preset;

    return InkWell(
      onTap: equalizerEnabled
          ? () {
              // If the equalizer is enabled, set the selected preset
              // and update the state
              EqualizerFlutter.setPreset(preset);
              setState(() {
                selectedPreset = preset;
              });
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.2) //selected
              : Colors.grey.withOpacity(0.1), //unselected
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display the preset name
            AppTextstyle(
              text: preset,
              style: appStyle(
                size: 16.sp,
                color: isSelected ? AppColors.primaryColor : Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            // Display a check icon if the preset is selected
            if (isSelected)
              Icon(Icons.check_circle,
                  color: AppColors.primaryColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
