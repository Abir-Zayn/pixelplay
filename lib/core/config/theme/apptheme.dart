import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class Apptheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyLarge: appStyle(
        color: AppColors.darkBackgroundColor,
        size: 24.sp,
        fontWeight: FontWeight.w800,
      ),
      bodyMedium: appStyle(
        color: AppColors.darkBackgroundColor,
        size: 18.sp,
        fontWeight: FontWeight.w800,
      ),
      bodySmall: appStyle(
        color: AppColors.darkBackgroundColor,
        size: 14.sp,
        fontWeight: FontWeight.w400,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.darkBackgroundColor,
        textStyle: appStyle(
          size: 21.sp,
          color: AppColors.darkBackgroundColor,
          fontWeight: FontWeight.bold,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    textTheme: TextTheme(
      bodyLarge: appStyle(
        color: AppColors.lightBackgroundColor,
        size: 24.sp,
        fontWeight: FontWeight.w800,
      ),
      bodyMedium: appStyle(
        color: AppColors.lightBackgroundColor,
        size: 18.sp,
        fontWeight: FontWeight.w800,
      ),
      bodySmall: appStyle(
        color: AppColors.lightBackgroundColor,
        size: 14.sp,
        fontWeight: FontWeight.w400,
      ),
    ),
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.lightBackgroundColor,
        textStyle: appStyle(
          size: 21.sp,
          color: AppColors.darkBackgroundColor,
          fontWeight: FontWeight.bold,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
    ),
  );
}
