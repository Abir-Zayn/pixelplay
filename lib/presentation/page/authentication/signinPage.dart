import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appTextField.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/model/auth/user_login.dart';
import 'package:pixelplayapp/domain/usecase/auth/signinUseCase.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5.h,
            left: 20.w,
            right: 20.w),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                Appvectors.applogoBasepath,
                height: 100.h,
                width: 100.w,
              ),
            ),

            AppTextstyle(
              text: "Sign In",
              style: appStyle(
                  size: 25.sp, color: color, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20.h,
            ),
            AppTextstyle(
              text: "Welcome back!",
              style: appStyle(
                  size: 17.sp, color: color, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 50.h,
            ),
            //Sign in - Email Textfield
            Apptextfield(
              controller: emailController,
              borderRadius: 20.r,
              hintText: "Enter your email",
              hintStyle: appStyle(
                  size: 17.sp, color: color, fontWeight: FontWeight.w200),
              height: 100.h,
              width: double.infinity,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[a-zA-Z0-9@.]+$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            //Sign in - Password Textfield
            Apptextfield(
              controller: passwordController,
              borderRadius: 20.r,
              hintText: "Password",
              hintStyle: appStyle(
                  size: 17.sp, color: color, fontWeight: FontWeight.w200),
              height: 100.h,
              width: double.infinity,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            Appbtn(
              text: "Sign In",
              color: AppColors.primaryColor,
              textColor: AppColors.lightBackgroundColor,
              fontSize: 20.sp,
              radius: 20.r,
              onPressed: () async {
                var result = await sl<Signinusecase>().call(
                  params: UserLogin(
                    userEmail: emailController.text.toString().trim(),
                    userPassword: passwordController.text.toString().trim(),
                  ),
                );
                result.fold(
                  (l) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  (r) {
                    // Handle success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: AppTextstyle(
                            text: r.toString(),
                            style: appStyle(
                                size: 13.sp,
                                color: AppColors.lightBackgroundColor,
                                fontWeight: FontWeight.w500)),
                      ),
                    );
                    context.go('/home');
                  },
                );
              },
              height: 80.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            GestureDetector(
              onTap: () {},
              child: AppTextstyle(
                text: "Recover your password",
                style: appStyle(
                    size: 16.sp,
                    color: color,
                    fontWeight: FontWeight.w400,
                    height: 2),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey, // Customize the divider color
                    thickness: 1, // Customize the divider thickness
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // Add padding around "Or"
                  child: AppTextstyle(
                      text: "OR",
                      style: appStyle(
                          size: 16.sp,
                          color: color,
                          fontWeight: FontWeight.w400,
                          height: 2)),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            //Sign in - Google Button & Apple Button
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.green,
                      size: 40.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.apple,
                      color: Colors.grey,
                      size: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
            //Register account
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextstyle(
                  text: "Don't have an account?",
                  style: appStyle(
                      size: 17.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                      height: 2),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/signup');
                  },
                  child: AppTextstyle(
                    text: "Sign Up",
                    style: appStyle(
                        size: 17.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        height: 2),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
