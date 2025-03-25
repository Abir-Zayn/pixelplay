import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/intro/bloc/theme_cubit.dart';

class Choosetheme extends StatelessWidget {
  const Choosetheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Appvectors.choosethemeBasepath),
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
                  text: "Choose Mode",
                  style: appStyle(
                      size: 20.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20.h,
                ),
                AppTextstyle(
                  text:
                      "Choose your preferred mode whether you love lighting & shining or dark & gloomy.",
                  style: appStyle(
                      size: 14.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.light);
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(77, 106, 106, 106),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Icon(CupertinoIcons.sun_max_fill,
                                    color: AppColors.lightBackgroundColor,
                                    size: 30.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppTextstyle(
                          text: "Light",
                          style: appStyle(
                              size: 14.sp,
                              color: AppColors.lightBackgroundColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.dark);
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(77, 106, 106, 106),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Icon(CupertinoIcons.moon_fill,
                                    color: AppColors.lightBackgroundColor,
                                    size: 30.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppTextstyle(
                          text: "Dark",
                          style: appStyle(
                              size: 14.sp,
                              color: AppColors.lightBackgroundColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.h,
                ),
                Appbtn(
                    text: "Continue",
                    onPressed: () {
                      context.go('/authchoice');
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
