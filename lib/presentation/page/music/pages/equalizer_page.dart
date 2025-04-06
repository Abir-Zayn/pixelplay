import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({super.key});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  bool equalizerEnabled = false;
  String? selectedPreset;
  final AudioPlayerService audioService = sl<AudioPlayerService>();
  late Future<List<String>> presetsFuture;

  @override
  void initState() {
    super.initState();
    EqualizerFlutter.init(0);
    presetsFuture = EqualizerFlutter.getPresetNames();
  }

  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  Future<void> _requestPermissionAndOpenEqualizer(BuildContext context) async {
    var status = await Permission.audio.request();
    if (status.isGranted) {
      try {
        await EqualizerFlutter.open(0);
      } on PlatformException catch (e) {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${e.message}\n${e.details}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission to access audio settings denied.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equalizer',
            style: appStyle(
                size: 20.sp, color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView(
          children: [
            SizedBox(height: 30.h),
            Center(
              child: ElevatedButton(
                onPressed: () => _requestPermissionAndOpenEqualizer(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
                child: Text(
                  'Open Device Equalizer',
                  style: appStyle(
                      size: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
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

  Widget _buildPresetSelector() {
    return FutureBuilder<List<String>>(
      future: presetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading presets: ${snapshot.error}',
              style: appStyle(
                  size: 14.sp, color: Colors.red, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          );
        }

        final presets = snapshot.data ?? [];
        if (presets.isEmpty) {
          return Center(
            child: Text(
              'No presets available',
              style: appStyle(
                  size: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: presets.map((preset) => _buildPresetTile(preset)).toList(),
        );
      },
    );
  }

  Widget _buildPresetTile(String preset) {
    bool isSelected = selectedPreset == preset;

    return InkWell(
      onTap: equalizerEnabled
          ? () {
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
              ? Colors.blue.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              preset,
              style: appStyle(
                size: 16.sp,
                color: isSelected ? Colors.blue : Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
