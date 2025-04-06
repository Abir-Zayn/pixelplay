import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          onSubmitted(value);
          controller.clear();
        },
        decoration: InputDecoration(
          hintText: 'Search for Songs or Artists',
          hintStyle: appStyle(
            size: 16.sp,
            color: AppColors.darkBackgroundColor.withOpacity(0.6),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 15.w, right: 10.w),
            child: Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18.sp,
              color: AppColors.darkBackgroundColor.withOpacity(0.7),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        ),
        style: appStyle(
          size: 16.sp,
          color: AppColors.darkBackgroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
