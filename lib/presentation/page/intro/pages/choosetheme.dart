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

class Choosetheme extends StatefulWidget {
  const Choosetheme({super.key});

  @override
  State<Choosetheme> createState() => _ChoosetThemeState();
}

class _ChoosetThemeState extends State<Choosetheme> {
  // Track selected theme to show visual indication
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // Initialize with current theme
    _selectedTheme = context.read<ThemeCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Appvectors.choosethemeBasepath),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // App logo
                  Image.asset(
                    Appvectors.applogoBasepath,
                    height: 180.h,
                    width: 180.w,
                  ),

                  SizedBox(height: 40.h),

                  // Header text
                  AppTextstyle(
                    text: "Choose Your Theme",
                    style: appStyle(
                      size: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Description
                  AppTextstyle(
                    text:
                        "Select a theme that suits your style. You can always change it later in settings.",
                    style: appStyle(
                      size: 16.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  SizedBox(height: 60.h),

                  // Theme selection options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Light mode option
                      _buildThemeOption(
                        icon: CupertinoIcons.sun_max_fill,
                        label: "Light",
                        theme: ThemeMode.light,
                      ),

                      SizedBox(width: 40.w),

                      // Dark mode option
                      _buildThemeOption(
                        icon: CupertinoIcons.moon_fill,
                        label: "Dark",
                        theme: ThemeMode.dark,
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // System theme option
                  _buildSystemThemeOption(),

                  Spacer(),

                  // Continue button
                  Appbtn(
                    text: "Continue",
                    onPressed: () {
                      // Save selected theme and navigate
                      context.read<ThemeCubit>().updateTheme(_selectedTheme);
                      context.go('/authchoice');
                    },
                    textColor: AppColors.lightBackgroundColor,
                    color: AppColors.primaryColor,
                    width: double.infinity,
                    height: 60.h,
                    fontSize: 18.sp,
                    radius: 12.r,
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required ThemeMode theme,
  }) {
    bool isSelected = _selectedTheme == theme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Column(
        children: [
          Container(
            height: 80.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.6)
                  : const Color.fromARGB(77, 106, 106, 106),
              borderRadius: BorderRadius.circular(50.r),
              border: isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 35.sp,
            ),
          ),
          SizedBox(height: 12.h),
          AppTextstyle(
            text: label,
            style: appStyle(
              size: 16.sp,
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemThemeOption() {
    bool isSelected = _selectedTheme == ThemeMode.system;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = ThemeMode.system;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : Border.all(color: Colors.white30, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            AppTextstyle(
              text: "Use System Settings",
              style: appStyle(
                size: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
