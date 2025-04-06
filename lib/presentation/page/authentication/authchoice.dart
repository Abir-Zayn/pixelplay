import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class Authchoice extends StatelessWidget {
  // Changed to StatelessWidget since we no longer need animation state
  const Authchoice({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamically determine text color based on current theme
    Color textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    // Create gradient based on theme
    List<Color> gradientColors =
        Theme.of(context).brightness == Brightness.light
            ? [Colors.white, Colors.blue.shade50]
            : [Colors.black87, Colors.indigo.shade900.withOpacity(0.6)];

    return Scaffold(
      // Use a gradient background that adapts to theme
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Decorative image at bottom-right
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  Appvectors.signinsignupImgPath1,
                  height: 220.h,
                  width: 220.w,
                ),
              ),
            ),

            // Decorative image at bottom-left
            Positioned(
              bottom: 0,
              left: 0,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  Appvectors.signinsignupImgPath2,
                  height: 200.h,
                  width: 200.w,
                ),
              ),
            ),

            // Main content container
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Logo section (without animation)
                    SizedBox(height: 20.h),
                    Container(
                      height: 180.h,
                      width: 180.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 25,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Image.asset(
                        Appvectors.applogoBasepath,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Main headline text
                    AppTextstyle(
                      text: "Enjoy Listening To Music",
                      style: appStyle(
                        size: 26.sp,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Description text
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: AppTextstyle(
                        text:
                            'Pixelplay is a propriety of audio streaming and media services provider and developed by Abir Zayn',
                        style: appStyle(
                          size: 16.sp,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),

                    SizedBox(height: 60.h),

                    // Authentication buttons
                    _buildAuthButtons(context),

                    // Add a text separator
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: textColor.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "OR",
                              style: appStyle(
                                size: 14.sp,
                                color: textColor.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: textColor.withOpacity(0.3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Continue as guest button
                    _buildGuestButton(context, textColor),

                    // Spacer pushes the rest of the content to the bottom
                    Spacer(),

                    // Terms and conditions text
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: AppTextstyle(
                        text:
                            "By continuing, you agree to our Terms of Service and Privacy Policy",
                        style: appStyle(
                          size: 12.sp,
                          color: textColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build sign up and login buttons
  Widget _buildAuthButtons(BuildContext context) {
    return Row(
      children: [
        // Sign Up Button - Primary colored button with rounded corners
        Expanded(
          child: Appbtn(
            color: AppColors.primaryColor,
            fontSize: 18.sp,
            text: "Sign Up",
            height: 60.h,
            width: 160.w,
            textColor: AppColors.lightBackgroundColor,
            radius: 15.r,
            onPressed: () {
              // Navigate to sign up screen
              context.go('/signup');
            },
          ),
        ),

        SizedBox(width: 16.w),

        // Login Button - Transparent button with border
        Expanded(
          child: Container(
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              // Create a subtle border
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.6),
                width: 2,
              ),
            ),
            child: Appbtn(
              color: Colors.transparent,
              fontSize: 18.sp,
              text: "Log In",
              height: 60.h,
              radius: 15.r,
              width: 160.w,
              textColor: Theme.of(context).brightness == Brightness.light
                  ? AppColors.primaryColor
                  : AppColors.lightBackgroundColor,
              onPressed: () {
                // Navigate to sign in screen
                context.go('/signin');
              },
            ),
          ),
        ),
      ],
    );
  }

  // Method to build the guest mode button
  Widget _buildGuestButton(BuildContext context, Color textColor) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: textColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            "Continue as Guest [UI] ",
            style: appStyle(
              size: 16.sp,
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
