import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/profile/bloc/cubit/profile_info_cubit_cubit.dart';
import 'package:pixelplayapp/presentation/page/profile/widget/favSongs.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  // Define a variable to hold the text color based on the theme
  Color textcolor = Colors.black;

  @override
  void initState() {
    super.initState();
    // You can initialize any data or state here if needed
  }

  @override
  Widget build(BuildContext context) {
    textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileInfo(context),
            const SizedBox(height: 20),
            GetFavSongWidget(
              textColor: textcolor,
            )
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubitCubit()..getUser(),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.94,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 3.0),
              ),
            ],
          ),
          child: BlocBuilder<ProfileInfoCubitCubit, ProfileInfoCubitState>(
              builder: (context, state) {
            if (state is ProfileInfoCubitLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileInfoCubitError) {
              // Show the snackbar but don't return it
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                  ),
                );
              });
            }
            if (state is ProfileInfoCubitLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppTextstyle(
                    text: state.userEntity.userName!,
                    style: appStyle(
                        size: 20.sp,
                        color: textcolor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  AppTextstyle(
                    text: state.userEntity.userEmail!,
                    style: appStyle(
                        size: 14.sp,
                        color: textcolor.withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  //Show the UserId and a button that allows to copy the UserId
                  AppTextstyle(
                    text: "User ID: ${state.userEntity.userId}",
                    style: appStyle(
                        size: 14.sp,
                        color: textcolor.withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the copy UserId functionality here
                      final userId = state.userEntity.userId!;
                      // Use a package like 'flutter/services.dart' to copy to clipboard
                      Clipboard.setData(ClipboardData(text: userId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.amber,
                          content: AppTextstyle(
                              text: "Copied Successfully",
                              style: appStyle(
                                  size: 12.sp,
                                  color: AppColors.darkBackgroundColor,
                                  fontWeight: FontWeight.w300)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                    ),
                    child: AppTextstyle(
                      text: "Copy User ID",
                      style: appStyle(
                          size: 14.sp,
                          color: AppColors.lightBackgroundColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
              
                  //Show Following + Followers List , Followers List will be static for now
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          AppTextstyle(
                            text: "Followers",
                            style: appStyle(
                                size: 15.sp,
                                color: textcolor,
                                fontWeight: FontWeight.w600),
                          ),
                          AppTextstyle(
                            text: "50",
                            style: appStyle(
                                size: 14.sp,
                                color: textcolor.withOpacity(0.6),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          AppTextstyle(
                            text: "Following",
                            style: appStyle(
                                size: 16.sp,
                                color: textcolor,
                                fontWeight: FontWeight.w600),
                          ),
                          AppTextstyle(
                            text: "50",
                            style: appStyle(
                                size: 14.sp,
                                color: textcolor.withOpacity(0.6),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              );
            }
            return const SizedBox
                .shrink(); // Return an empty widget if no state matches
          }),
        ),
      ),
    );
  }
}
