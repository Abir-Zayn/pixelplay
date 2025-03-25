import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';

class Appbtn extends StatelessWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final double radius;
  final Color textColor;
  final double fontSize;
  final IconData? icon;
  final bool isIconLeading;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onPressed;
  const Appbtn(
      {super.key,
      required this.text,
      this.color = Colors.transparent,
      this.width = double.infinity,
      this.height = 50,
      this.radius = 8,
      this.textColor = AppColors.lightBackgroundColor,
      this.fontSize = 16,
      this.icon,
      this.isIconLeading = true,
      this.iconColor,
      this.iconSize,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && isIconLeading)
              Icon(
                icon,
                color: iconColor ?? AppColors.lightBackgroundColor,
                size: iconSize ?? 20.sp,
              ),
            if (icon != null && isIconLeading) SizedBox(width: 8.w),
            AppTextstyle(
              text: text,
              style: appStyle(
                size: fontSize,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            if (icon != null && !isIconLeading) SizedBox(width: 8.w),
            if (icon != null && !isIconLeading)
              Icon(
                icon,
                color: iconColor ?? AppColors.lightBackgroundColor,
                size: iconSize ?? 20.sp,
              ),
            if (icon == null && !isIconLeading)
              const SizedBox(
                width: 0,
              ),
          ],
        ),
      ),
    );
  }
}
