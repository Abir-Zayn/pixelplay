import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/src/audio_player_service.dart';
import 'package:pixelplayapp/domain/repo/auth_repo.dart';
import 'package:pixelplayapp/presentation/page/profile/bloc/cubit/profile_info_cubit_cubit.dart';
import 'package:pixelplayapp/presentation/page/profile/widget/favSongs.dart';
import 'package:toastification/toastification.dart';

class Profilepage extends StatefulWidget {
  final AudioPlayerService audioPlayerService = sl<AudioPlayerService>();
  Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Color textcolor = Colors.black;

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
    textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]
          : Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: appStyle(
            size: 20.sp,
            color: textcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black.withOpacity(0.8),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textcolor),
            onPressed: () {
              // Settings action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _profileInfo(context),
            const SizedBox(height: 20),
            _buildSectionTitle("Favorite Songs"),
            const SizedBox(height: 10),
            GetFavSongWidget(
              textColor: textcolor,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: appStyle(
              size: 18.sp,
              color: textcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              // View all action
            },
            child: Text(
              "See All",
              style: appStyle(
                size: 14.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubitCubit()..getUser(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BlocBuilder<ProfileInfoCubitCubit, ProfileInfoCubitState>(
          builder: (context, state) {
            if (state is ProfileInfoCubitLoading) {
              return SizedBox(
                height: 400.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is ProfileInfoCubitError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                toastification.show(
                  context: context,
                  backgroundColor: Colors.red,
                  title: AppTextstyle(
                      text: 'Something Went Wrong',
                      style: appStyle(
                          size: 16.sp,
                          color: textcolor,
                          fontWeight: FontWeight.w500)),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                );
              });
            }
            if (state is ProfileInfoCubitLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile header
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Profile image with border
                          Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 2.w,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 55.r,
                              backgroundImage: const NetworkImage(
                                "https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Username
                          AppTextstyle(
                            text: state.userEntity.userName!,
                            style: appStyle(
                              size: 22.sp,
                              color: textcolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Email
                          AppTextstyle(
                            text: state.userEntity.userEmail!,
                            style: appStyle(
                              size: 14.sp,
                              color: textcolor.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats section (followers/following)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("50", "Followers"),
                          _buildDivider(),
                          _buildStatItem("50", "Following"),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          // User ID with copy button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[100]
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: textcolor.withOpacity(0.7),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    "ID: ${state.userEntity.userId}",
                                    style: appStyle(
                                      size: 14.sp,
                                      color: textcolor.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final userId = state.userEntity.userId!;
                                    Clipboard.setData(
                                        ClipboardData(text: userId));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: AppColors.primaryColor,
                                        content: Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: Colors.white,
                                                size: 16.sp),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Copied to clipboard",
                                              style: appStyle(
                                                size: 14.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.copy,
                                      color: AppColors.primaryColor,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Logout button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                widget.audioPlayerService.stop();
                                widget.audioPlayerService.dispose();
                                await sl<AuthRepo>().signOut();
                                //Sign out the user and navigate to the sign-in page
                                // and dispose the audio player service
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  toastification.show(
                                    context: context,
                                    backgroundColor: Colors.yellow,
                                    title: AppTextstyle(
                                        text: 'SignOut Successfully',
                                        style: appStyle(
                                            size: 16.sp,
                                            color: textcolor,
                                            fontWeight: FontWeight.w500)),
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                    type: ToastificationType.info,
                                  );
                                });
                                context.go('/signin');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout_rounded, size: 18.sp),
                                  SizedBox(width: 8.w),
                                  AppTextstyle(
                                    text: "Log Out",
                                    style: appStyle(
                                      size: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: appStyle(
            size: 20.sp,
            color: textcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: appStyle(
            size: 14.sp,
            color: textcolor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30.h,
      width: 1.w,
      color: textcolor.withOpacity(0.2),
    );
  }
}
