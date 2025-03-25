import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class Authchoice extends StatefulWidget {
  const Authchoice({super.key});

  @override
  State<Authchoice> createState() => _AuthchoiceState();
}

class _AuthchoiceState extends State<Authchoice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      body: Stack(children: [
        Positioned(
          bottom: 0,
          right: 20.w,
          top: 200.h,
          child: Opacity(
            opacity: 0.7,
            child: Image.asset(
              Appvectors.signinsignupImgPath1,
              height: 200.h,
              width: 200.w,
            ),
          ),
        ),
        Container(
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
                AppTextstyle(
                  text: "Enjoy Listening To Music",
                  style: appStyle(
                      size: 24.sp,
                      color: textcolor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AppTextstyle(
                  text:
                      'Spotify is a propriety Swedish audio streaming and media services provider.',
                  style: appStyle(
                      size: 14.sp,
                      color: textcolor,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Appbtn(
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                      text: "Sign Up",
                      height: 80.h,
                      width: 160.w,
                      textColor: AppColors.lightBackgroundColor,
                      onPressed: () {
                        context.go('/signup');
                      },
                    ),
                    Appbtn(
                      color: Colors.transparent,
                      fontSize: 20.sp,
                      text: "Log In",
                      height: 80.h,
                      width: 160.w,
                      textColor: AppColors.lightBackgroundColor,
                      onPressed: () {
                        context.go('/signin');
                      },
                    ),
                  ],
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      Appvectors.signinsignupImgPath2,
                      height: 200.h,
                      width: 200.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
