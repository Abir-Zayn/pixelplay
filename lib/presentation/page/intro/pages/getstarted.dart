import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class Getstarted extends StatelessWidget {
  const Getstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
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
                    onPressed: () {
                      context.go('/choosetheme');
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
