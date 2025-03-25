import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/new_songs.dart';
import 'package:pixelplayapp/presentation/page/root/widgets/play_list.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with the number of tabs you have
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the TabController when the widget is removed from the widget tree
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Image.asset(
            Appvectors.applogoBasepath,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.user,
              color: textcolor,
            ),
            onPressed: () {
              // Navigate to the profile page
              context.push('/profile');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: _homeArtistCard()),
                SizedBox(
                  height: 30.h,
                ),
                _tabs(textcolor),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  height: 250.h,
                  child: TabBarView(controller: _tabController, children: [
                    Container(),
                    NewSongs(color: textcolor),
                    Container(),
                    Container(),
                  ]),
                ),
                SizedBox(
                  height: 20.h,
                ),
                PlayList(color: textcolor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeArtistCard() {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Content area (left side)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextstyle(
                  text: "New Album (UI Design)",
                  style: appStyle(
                      size: 12.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.h),
                AppTextstyle(
                  text: "Lose Yourself",
                  style: appStyle(
                      size: 25.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.h),
                AppTextstyle(
                  text: "Eminem",
                  style: appStyle(
                      size: 14.sp,
                      color: AppColors.lightBackgroundColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // Artist image (right side)
          Positioned(
            top: 0,
            bottom: 0.h,
            right: 0.w,
            width: 130.w,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
              child: Image.asset(
                Appvectors.signinsignupImgPath2,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs(Color textColor) {
    return TabBar(
      dividerColor: Colors.transparent,
      controller: _tabController,
      isScrollable: true,
      labelColor: textColor,
      indicatorColor: AppColors.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        AppTextstyle(
          text: "News",
          style: appStyle(
              size: 16.sp, color: textColor, fontWeight: FontWeight.w500),
        ),
        AppTextstyle(
          text: "New Releases",
          style: appStyle(
              size: 16.sp, color: textColor, fontWeight: FontWeight.w500),
        ),
        AppTextstyle(
          text: "Artists",
          style: appStyle(
              size: 16.sp, color: textColor, fontWeight: FontWeight.w500),
        ),
        AppTextstyle(
          text: "Podcasts",
          style: appStyle(
              size: 16.sp, color: textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
