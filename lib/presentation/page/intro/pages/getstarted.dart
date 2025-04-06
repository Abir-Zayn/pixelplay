import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:toastification/toastification.dart';

class Getstarted extends StatelessWidget {
  const Getstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // The Following container is used to set the background image of the screen
        // The image is set to fit the height of the screen
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,

              // The image is set to the path of the image in the assets folder
              // To reusability the image path is set in the appvectors.dart file
              image: AssetImage(Appvectors.getstartedBasepath),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 5.h,
                left: 20.w,
                right: 20.w),
            child: Column(
              children: [
                // The following widget is used to set the logo of the app in the center of the screen
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Image.asset(
                      Appvectors.applogoBasepath,
                      height: 200.h,
                      width: 200.w,
                    ),
                  ),
                ),
                Spacer(),
                AppTextstyle(
                  text: "Enjoy Listen to music",
                  style: appStyle(
                      size: 18.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20.h,
                ),
                AppTextstyle(
                  text:
                      'Get instant access to millions of songs, personalized playlists, and more. Let\'s set up your account',
                  style: appStyle(
                      size: 14.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Appbtn(
                    text: "Get Started",
                    /*
                    Permission Handler is used to request permission from the user to access the storage 
                    and audio of the device. Its necessary to request permission as in the app Im using
                    equalizer for audio therefore I need to access storage and audio of the device.

                    If the permission granted already -> go to the next screen
                    If the permission is not granted -> request permission from the user
                    If the permission denied -> show system settings to allow permission
                    */
                    onPressed: () async {
                      // First check if permissions are already granted
                      var storageStatus = await Permission.storage.status;
                      var audioStatus = await Permission.audio.status;

                      print("Current storage status: $storageStatus");
                      print("Current audio status: $audioStatus");

                      // If any permission is already granted, proceed
                      if (storageStatus.isGranted || audioStatus.isGranted) {
                        print("Permission already granted!");

                        // Proceed to the next screen by showing a success toast
                        toastification.show(
                            context: context,
                            title: AppTextstyle(
                                text: 'Permission Granted',
                                style: appStyle(
                                    size: 16.sp,
                                    color: AppColors.darkBackgroundColor,
                                    fontWeight: FontWeight.w500)),
                            autoCloseDuration: const Duration(seconds: 2),
                            type: ToastificationType.success);
                        context.go('/choosetheme');
                        return;
                      }

                      // If permissions need to be requested:
                      PermissionStatus status;

                      // First try audio permission
                      status = await Permission.audio.request();

                      // If not granted, try storage permission
                      if (!status.isGranted) {
                        status = await Permission.storage.request();
                      }

                      if (status.isGranted) {
                        print("Permission granted!");
                        toastification.show(
                            context: context,
                            title: AppTextstyle(
                                text: 'Permission Granted',
                                style: appStyle(
                                    size: 16.sp,
                                    color: AppColors.darkBackgroundColor,
                                    fontWeight: FontWeight.w500)),
                            autoCloseDuration: const Duration(seconds: 2),
                            type: ToastificationType.success);
                        context.go('/choosetheme');
                      } else {
                        print("Permission denied: $status");
                        toastification.show(
                            context: context,
                            title: AppTextstyle(
                                text: 'Permission Denied',
                                style: appStyle(
                                    size: 16.sp,
                                    color: AppColors.darkBackgroundColor,
                                    fontWeight: FontWeight.w500)),
                            autoCloseDuration: const Duration(seconds: 2),
                            type: ToastificationType.error);

                        Future.delayed(const Duration(seconds: 2), () {
                          openAppSettings();
                        });
                      }
                    },
                    textColor: AppColors.lightBackgroundColor,
                    color: AppColors.primaryColor,
                    width: MediaQuery.of(context).size.width - 40.w,
                    height: 60.h,
                    fontSize: 20.sp,
                    radius: 8.r),
                SizedBox(
                  height: 40.h,
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
